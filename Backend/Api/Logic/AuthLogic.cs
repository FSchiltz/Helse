using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text.Json;
using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Models;
using LinqToDB;
using Microsoft.AspNetCore.Identity;

namespace Api.Logic;

/// <summary>
/// Data needed to start a connection
/// </summary>
/// <param name="User"></param>
/// <param name="Password"></param>
public record Connection(string User, string Password, string? Redirect);

public record Status(bool Init, bool ExternalAuth, string? Error, string? Oauth, string? OauthId, bool AutoLogin);

/// <summary>
/// Logic over user authentication and right
/// </summary>
public static class AuthLogic
{
    private static readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true
    };

    /// <summary>
    /// Return true if the server is correctly installed
    /// If false, some steps are missing:
    ///     - Missing first user
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <param name="logger"></param>
    /// <returns></returns>
    public static async Task<IResult> StatusAsync(AppDataConnection db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger("Auth");

        // check if the server is already init
        var count = await db.GetTable<User>().CountAsync();

        if (count == 0)
        {
            log.LogInformation("First connexion");
            return TypedResults.Ok(new Status(false, false, null, null, null, false));
        }

        var isAuth = false;

        string? oauthUrl = null;
        string? oauthId = null;
        var oauth = await db.GetSettings<Oauth>(Oauth.Name);
        if (oauth?.Enabled == true)
        {
            oauthUrl = oauth.Url;
            oauthId = oauth.ClientId;
        }
        else
        {
            // now we check if the user is already auth
            var proxy = await db.GetSettings<Proxy>(Proxy.Name);
            if (proxy?.ProxyAuth == true && proxy.Header is not null)
            {
                (isAuth, _) = await ConnectHeader(db, context, proxy, log);
            }
        }

        log.LogInformation("Status asked");
        return TypedResults.Ok(new Status(true, isAuth, null, oauthUrl, oauthId, oauth?.AutoLogin ?? false));
    }

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> AuthAsync(Connection user, AppDataConnection db, HttpContext context, TokenService token, ILoggerFactory logger)
    {
        var log = logger.CreateLogger("Auth");

        var settings = await db.GetSettings<Proxy>(Proxy.Name);
        var oauth = await db.GetSettings<Oauth>(Oauth.Name);
        bool logged = false;
        TokenInfo? fromDb = null;

        if (settings?.ProxyAuth == true && settings.Header is not null)
        {
            log.LogInformation("Connexion by header");
            (logged, fromDb) = await ConnectHeader(db, context, settings, log);
        }
        else if (oauth.Enabled && user.Redirect is not null)
        {
            log.LogInformation("Logging from oauth using  {redirect}", user.Redirect);
            (logged, fromDb) = await ConnectOauth(db, oauth, user, log);
        }

        // Custom auth didn't work, fall back on password
        if (!logged)
        {
            // Fallback on the password if the other means failed
            log.LogInformation("Connexion by username");
            (logged, fromDb) = await ConnectPassword(user, db, context, log);
        }

        if (!logged || fromDb is null)
            return TypedResults.Unauthorized();

        log.LogDebug("Connexion validated");

        return TypedResults.Ok(token.GetToken(fromDb));
    }

    public async static Task UpdatePasswordAsync(long user, string password, AppDataConnection db)
    {
        var hash = TokenService.Hash(password);

        await db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();
    }

    /// <summary>
    /// Check that a user has the given right over someone
    /// </summary>
    /// <param name="user"></param>
    /// <param name="person"></param>
    /// <param name="type"></param>
    /// <param name="time"></param>
    /// <param name="db"></param>
    /// <returns></returns>
    public async static Task<Api.Models.Right?> HasRightAsync(long user, long person, RightType type, DateTime time, AppDataConnection db)
     => (await db.GetTable<Data.Models.Right>()
        .Where(x => x.UserId == user
            && x.PersonId == person
            && x.Type == (int)type
            && x.Start <= time
            && (x.Stop == null || x.Stop >= time))
        .FirstOrDefaultAsync())?.FromDb();

    /// <summary>
    /// Validate that the user is a caregiver with the correct right
    /// </summary>
    /// <param name="db"></param>
    /// <param name="user"></param>
    /// <param name="personId"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    internal static async Task<bool> ValidateCaregiverAsync(this AppDataConnection db, Data.Models.User user, long personId, RightType type)
    {
        var now = DateTime.UtcNow;
        // check if the user has the right 
        var right = await HasRightAsync(user.Id, personId, type, now, db);
        return right is not null;
    }

    internal static async Task<IResult?> IsAdmin(this AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (user.Type != (int)Models.UserType.Admin)
            return TypedResults.Forbid();

        return null;
    }

    internal static async Task<(IResult?, User)> GetUser(this AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return (TypedResults.Unauthorized(), User.Empty);

        return (null, user);
    }

    private static async Task<TokenInfo?> TokenFromDb(this AppDataConnection db, string user)
    {
        var fromDb = await (from u in db.GetTable<User>()
                            join p in db.GetTable<Data.Models.Person>() on u.PersonId equals p.Id
                            where u.Identifier == user
                            select new { u, p })
                                 .FirstOrDefaultAsync();
        if (fromDb is null)
            return null;

        return new TokenInfo(fromDb.u.Id, fromDb.u.Type.ToString(), fromDb.u.Identifier, fromDb.u.Password, fromDb.p.Surname, fromDb.p.Name, fromDb.u.Email);
    }

    private static async Task<(bool, TokenInfo?)> ConnectHeader(AppDataConnection db, HttpContext context, Proxy settings, ILogger log)
    {
        if (settings.Header is null)
        {
            return (false, null);
        }

        log.LogInformation("Connexion by proxy tentative using {header} in {headers}", settings.Header, context.Request.Headers);
        context.Request.Headers.TryGetValue(settings.Header, out var headers);
        var header = headers.FirstOrDefault();

        if (header is not null)
        {
            log.LogInformation("Connexion by proxy auth header {header} and user {user}", settings.Header, header);
        }
        else
        {
            log.LogWarning("Connexion by proxy auth header {header} rejected", settings.Header);
            return (false, null);
        }

        var fromDb = await TokenFromDb(db, header);

        var logged = false;
        if (fromDb is null)
        {
            if (settings.AutoRegister)
            {
                log.LogInformation("User created for {header}", context.Request.Headers);
                // If auto register and not found, we create it
                await db.CreateUserAsync(new PersonCreation
                {
                    UserName = header,
                    Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                    Type = UserType.User
                }, 0);
                logged = true;
                fromDb = await TokenFromDb(db, header);
            }
        }
        else
        {
            logged = true;
        }

        return (logged, fromDb);
    }

    private static async Task<(bool, TokenInfo?)> ConnectPassword(Connection user, AppDataConnection db, HttpContext context, ILogger log)
    {
        // auth
        var fromDb = await TokenFromDb(db, user.User);

        if (fromDb is null)
            return (false, null);

        var passwordStatus = TokenService.Verify(user.Password, fromDb.Password);

        // generate the token
        switch (passwordStatus)
        {
            case PasswordVerificationResult.Success:
                // Success, nothing to do
                break;
            case PasswordVerificationResult.SuccessRehashNeeded:
                // Success but the password needs an update
                await UpdatePasswordAsync(fromDb.Id, user.Password, db);
                break;
            case PasswordVerificationResult.Failed:
            default:
                log.LogWarning("Unauthorized access to getToken with user {user}", user.User);
                return (false, null);
        }

        return (true, fromDb);
    }

    private static async Task<(bool logged, TokenInfo? fromDb)> ConnectOauth(AppDataConnection db, Oauth oauth, Connection user, ILogger log)
    {
        var token = await oauth.GetOauthTokenAsync(user);

        var fromDb = await db.TokenFromDb(token.User);

        var logged = false;
        if (fromDb is null)
        {
            if (oauth.AutoRegister)
            {
                log.LogInformation("User created for {header}", user.Redirect);
                // If auto register and not found, we create it
                await db.CreateUserAsync(new PersonCreation
                {                    
                    UserName = token.User,
                    Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                    Type = UserType.User,
                    Name = token.Name,
                }, 0);
                logged = true;
                fromDb = await TokenFromDb(db, token.User);
            }
        }
        else
        {
            logged = true;
        }

        return (logged, fromDb);
    }

    private static async Task<Token> GetOauthTokenAsync(this Oauth oauth, Connection user)
    {
        // get the jwt token from the oauth server
        using var client = new HttpClient();

        using var content = new FormUrlEncodedContent([
            new ("grant_type","authorization_code"),
            new ("code", user.Password),
            new ("redirect_uri", user.Redirect),
        ]);

        var authenticationString = $"{oauth.ClientId}:{oauth.ClientSecret}";
        var base64EncodedAuthenticationString = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(authenticationString));

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", base64EncodedAuthenticationString);
        var response = await client.PostAsync(oauth.Tokenurl, content);

        var contentString = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();
        return Parse(contentString);
    }

    private record Token(string User, string? Name);
    private class OauthToken
    {
        public string? Access_token { get; set; }
    }

    private static Token Parse(string content)
    {
        var auth = JsonSerializer.Deserialize<OauthToken>(content, _options);

        var jwt = auth?.Access_token ?? throw new InvalidOperationException("Incorrect token");

        var token = new JwtSecurityTokenHandler().ReadJwtToken(jwt);

        var claim = token.Payload.Claims.First(x => x.Type == "preferred_username" || x.Type == JwtRegisteredClaimNames.UniqueName);
        var name = token.Payload.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Name || x.Type == JwtRegisteredClaimNames.FamilyName);
        return new Token(claim.Value, name?.Value ?? claim.Value);
    }
}
