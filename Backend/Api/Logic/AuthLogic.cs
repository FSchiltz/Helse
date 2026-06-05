using System.Text;
using Api.Data;
using Api.Data.Models.Persons;
using Api.Helpers.Auth;
using Api.Models;
using Api.Models.Persons;
using Api.Models.Settings.Admin;
using Microsoft.IdentityModel.Tokens;

namespace Api.Logic;

public record OauthConnection(string Name, string Url, string ClientId, bool AutoLogin);

public record Status(bool Init, bool ExternalAuth, string? Error, OauthConnection[] Oauths);

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

    public static async Task<IResult> RefreshAsync(IUserContext users, TokenService token, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(AuthLogic));
        var user = context.User.GetUser("refresh");
        if (user != null)
        {
            // the refresh token is valid
            var fromDb = await users.Get(user);
            if (fromDb is not null)
            {                
                var accessToken = token.GetAccessToken(fromDb, DateTime.UtcNow.AddMinutes(5));

                var roles = GetRoles(fromDb.Type);

                log.LogInformation("Refreshed access for user {user}", user);

                return TypedResults.Ok(new ConnectionResponse(accessToken, null, roles));
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
            log.LogInformation("Logging from oauth using {client}", user.Issuer);
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

        var accessToken = token.GetAccessToken(fromDb, DateTime.UtcNow.AddMinutes(5));
        var refreshToken = token.GetRefreshToken(fromDb, DateTime.UtcNow.AddDays(30));

        return TypedResults.Ok(new ConnectionResponse(accessToken, refreshToken, roles));
    }

    private static Models.Persons.UserType[] GetRoles(int type)
    {
        return [.. Enum.GetValues<Data.Models.Persons.UserType>()
                              .Where(e => e != Data.Models.Persons.UserType.Patient && ((Data.Models.Persons.UserType)type).HasFlag(e))
                              .Cast<Models.Persons.UserType>()];
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
