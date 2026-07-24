using System.Net;
using System.Text;
using Helse.Api.Data;
using Helse.Api.Data.Models.Persons;
using Helse.Api.Helpers.Auth;
using Helse.Models;
using Helse.Models.Admin;
using Helse.Models.Persons;
using Helse.Models.Settings.Admin;
using Microsoft.IdentityModel.Tokens;

namespace Helse.Api.Logic;

/// <summary>
/// Logic over user authentication and right
/// </summary>
internal static class AuthLogic
{
    public static RouteGroupBuilder MapAuth(this RouteGroupBuilder api)
    {
        /* User endpoints */
        api.MapPost("/auth", AuthAsync)
        .AllowAnonymous()
        .WithDescription("Get a connection token")
        .Produces<ConnectionResponse>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/refresh", RefreshAsync)
        .RequireAuthorization()
        .Produces<ConnectionResponse>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/status", StatusAsync)
        .AllowAnonymous()
        .WithDescription("Check if the server install is ready")
        .Produces<Status>((int)HttpStatusCode.OK);

        api.MapGet("/logout", LogoutAsync)
        .RequireAuthorization()
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/sessions", GetSessions)
        .RequireAuthorization()
        .Produces<Session[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    public static async Task<IResult> LogoutAsync(IUserContext users, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));
        var isRefresh = context.User.IsRefresh();
        if (isRefresh)
        {
            var user = context.User.GetUser(TokenHelper.Refresh);
            var userSession = context.User.GetSession();
            if (user != null && userSession != null)
            {
                var fromDb = await users.Get(user);
                if (fromDb is not null)
                {
                    await users.DeleteSession(fromDb.Id, userSession);
                    return TypedResults.NoContent();
                }
            }
        }
        else
        {
            var user = context.User.GetUser(TokenHelper.Access);
            var fromDb = await users.Get(user);
            if (fromDb is not null)
            {
                await users.DeleteSession(fromDb.Id);
                return TypedResults.NoContent();
            }
        }

        return TypedResults.Unauthorized();
    }

    public static async Task<IResult> GetSessions(IUserContext users, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));
        var user = context.User.GetUser();
        if (user != null)
        {
            var fromDb = await users.Get(user);
            if (fromDb is not null)
            {
                var sessions = await users.GetSessions(fromDb.Id);
                return TypedResults.Ok(sessions.Select(x => new Models.Persons.Session
                {
                    Ip = x.Ip,
                    Location = x.Location,
                    SessionId = x.SessionId,
                    Start = x.Start,
                    Stop = x.Stop,
                    UserAgent = x.UserAgent,
                }).ToArray());
            }
        }

        return TypedResults.Unauthorized();
    }
    /// <summary>
    /// Return true if the server is correctly installed
    /// If false, some steps are missing:
    ///     - Missing first user
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="context"></param>
    /// <param name="logger"></param>
    /// <returns></returns>
    public static async Task<IResult> StatusAsync(ISettingsContext settings, IUserContext users, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));

        // check if the server is already init
        var count = await users.Count();

        if (count == 0)
        {
            log.LogInformation("First connexion");
            return TypedResults.Ok(new Status(false, false, null, []));
        }

        var isAuth = false;

        OauthConnection[] oauths = [];
        var oauth = await settings.GetSettings<Oauth>(Oauth.Name);
        if (oauth.Enabled)
        {
            oauths = [.. oauth.Providers.Select(p => new OauthConnection(p.Name, p.Url, p.ClientId, p.AutoLogin))];
        }
        else
        {
            // now we check if the user is already auth
            var proxy = await settings.GetSettings<Proxy>(Proxy.Name);
            if (proxy?.ProxyAuth == true && proxy.Header is not null)
            {
                (isAuth, _) = await ProxyAuthHelper.ConnectHeader(users, context, proxy, log);
            }
        }

        log.LogInformation("Status asked");
        return TypedResults.Ok(new Status(true, isAuth, null, oauths));
    }

    private static DateTime TokenValidity(bool longLife)
    {
        if (longLife)
        {
            return DateTime.UtcNow.AddDays(30);
        }

        return DateTime.UtcNow.AddMinutes(10);
    }

    public static async Task<IResult> RefreshAsync(IUserContext users, TokenService token, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));
        var user = context.User.GetUser(TokenHelper.Refresh);
        var userSession = context.User.GetSession();
        if (user != null && userSession != null)
        {
            // the refresh token is valid
            var fromDb = await users.Get(user);
            if (fromDb is not null)
            {
                var session = await users.GetSession(fromDb.Id, userSession);

                if (session != null && session.Stop >= DateTime.UtcNow)
                {
                    var accessToken = token.GetAccessToken(fromDb, TokenValidity(false));

                    var roles = GetRoles(fromDb.Type);

                    log.LogInformation("Refreshed access for user {User}", user);

                    return TypedResults.Ok(new ConnectionResponse(fromDb.Identifier, accessToken, null, roles));
                }
            }
        }

        log.LogWarning("Failed attempt to use a refresh token");

        return TypedResults.Unauthorized();
    }

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> AuthAsync(Connection user, ISettingsContext settings, IUserContext users, TokenService token, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));

        var proxy = await settings.GetSettings<Proxy>(Proxy.Name);
        var oauth = await settings.GetSettings<Oauth>(Oauth.Name);
        bool logged = false;
        User? fromDb = null;

        // Unauth call
        if (proxy?.ProxyAuth == true && proxy.Header is not null)
        {
            log.LogInformation("Connexion by header");
            (logged, fromDb) = await ProxyAuthHelper.ConnectHeader(users, context, proxy, log);
        }

        if (!logged && oauth.Enabled && user.Issuer is not null)
        {
            log.LogInformation("Logging from oauth using {Client}", user.Issuer);
            (logged, fromDb) = await OauthHelper.ConnectOauth(users, oauth, user, log);
        }

        // Custom auth didn't work, fall back on password
        if (!logged)
        {
            // Fallback on the password if the other means failed
            log.LogInformation("Connexion by username");
            (logged, fromDb) = await PasswordHelper.ConnectPassword(user, users, log);
        }

        if (!logged || fromDb is null)
            return TypedResults.Unauthorized();

        log.LogDebug("Connexion validated");
        var roles = GetRoles(fromDb.Type);

        var accessToken = token.GetAccessToken(fromDb, TokenValidity(false));
        var sessionId = Guid.NewGuid();
        var refreshValidity = TokenValidity(true);
        var refreshToken = token.GetRefreshToken(fromDb, refreshValidity, sessionId);
        var userIp = context.Connection.RemoteIpAddress?.ToString();
        var userSession = new Sessions()
        {
            SessionId = sessionId.ToString(),
            Start = DateTime.UtcNow,
            Stop = refreshValidity,
            UserId = fromDb.Id,
            UserAgent = context.Request.Headers.UserAgent.ToString(),
            Ip = userIp,
            Location = null,
        };

        // clean up old sessions
        await users.DeleteSession(fromDb.Id, DateTime.UtcNow.AddDays(-30));
        await users.AddSession(userSession);

        return TypedResults.Ok(new ConnectionResponse(fromDb.Identifier, accessToken, refreshToken, roles));
    }

    private static Helse.Models.Persons.UserType[] GetRoles(int type)
    {
        return [.. Enum.GetValues<Data.Models.Persons.UserType>()
                              .Where(e => e != Data.Models.Persons.UserType.Patient && ((Data.Models.Persons.UserType)type).HasFlag(e))
                              .Cast<Helse.Models.Persons.UserType>()];
    }

    internal static SymmetricSecurityKey GenerateKey(string keyConfig)
    {
        var keyText = Encoding.UTF8.GetBytes(keyConfig).Take(512).ToArray();
        var generatedKey = new byte[512];
        var startAt = generatedKey.Length - keyText.Length;
        Array.Copy(keyText, 0, generatedKey, startAt, keyText.Length);
        return new SymmetricSecurityKey(generatedKey);
    }
}
