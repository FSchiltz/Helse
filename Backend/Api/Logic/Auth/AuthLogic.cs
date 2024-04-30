using Api.Data;
using Api.Data.Models;
using Api.Helpers.Auth;
using Api.Models;
using LinqToDB;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace Api.Logic.Auth;

/// <summary>
/// Data needed to start a connection
/// </summary>
/// <param name="User"></param>
/// <param name="Password"></param>
public record Connection(string User, string Password, string? Redirect);

public record Status(bool Init, bool ExternalAuth, string? Error, string? Oauth, string? OauthId, bool AutoLogin);

public record TokenResponse(string AccessToken, string RefreshToken);

/// <summary>
/// Logic over user authentication and right
/// </summary>
public static class AuthLogic
{
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
                (isAuth, _) = await ProxyAuthLogic.ConnectHeader(db, context, proxy, log);
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
        bool needNewRefreshToken = true;

        var auth = await context.AuthenticateAsync(JwtBearerDefaults.AuthenticationScheme);
        if (auth.Succeeded)
        {
            // The user just wants a new access token
            var claimsPrincipal = auth.Principal;
            var userNameFromRefreshToken = claimsPrincipal.GetUser("refresh");
            if (userNameFromRefreshToken is not null)
            {
                // the refresh token is valid
                fromDb = await db.TokenFromDb(userNameFromRefreshToken);
                logged = true;
                needNewRefreshToken = false;
            }
        }
        else
        {
            // Unauth call

            if (settings?.ProxyAuth == true && settings.Header is not null)
            {
                log.LogInformation("Connexion by header");
                (logged, fromDb) = await ProxyAuthLogic.ConnectHeader(db, context, settings, log);
            }
            else if (oauth.Enabled && user.Redirect is not null)
            {
                log.LogInformation("Logging from oauth using  {redirect}", user.Redirect);
                (logged, fromDb) = await OauthLogic.ConnectOauth(db, oauth, user, log);
            }

            // Custom auth didn't work, fall back on password
            if (!logged)
            {
                // Fallback on the password if the other means failed
                log.LogInformation("Connexion by username");
                (logged, fromDb) = await PasswordLogic.ConnectPassword(user, db, log);
            }
        }

        if (!logged || fromDb is null)
            return TypedResults.Unauthorized();

        log.LogDebug("Connexion validated");

        var accessToken = token.GetAccessToken(fromDb, DateTime.UtcNow.AddSeconds(30));
        var refreshToken = needNewRefreshToken ? token.GetRefreshToken(fromDb, DateTime.UtcNow.AddMinutes(3)) : string.Empty;

        return TypedResults.Ok(new TokenResponse(accessToken, refreshToken));
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

    public static async Task<TokenInfo?> TokenFromDb(this AppDataConnection db, string user)
    {
        var fromDb = await (from u in db.GetTable<User>()
                            join p in db.GetTable<Data.Models.Person>() on u.PersonId equals p.Id
                            where u.Identifier == user
                            select new { u, p })
                                 .FirstOrDefaultAsync();
        if (fromDb is null)
            return null;

        return new TokenInfo(fromDb.u.Id, fromDb.u.Type.ToString(),
         fromDb.u.Identifier, fromDb.u.Password, fromDb.p.Surname, fromDb.p.Name, fromDb.u.Email);
    }
}
