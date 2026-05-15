using System.Text;
using Api.Data;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models;
using Api.Models.Settings.Admin;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

namespace Api.Logic.Auth;

public record OauthConnection(string Name, string Url, string ClientId, bool AutoLogin);

public record Status(bool Init, bool ExternalAuth, string? Error, OauthConnection[] Oauths);

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
    /// <param name="settings"></param>
    /// <param name="context"></param>
    /// <param name="logger"></param>
    /// <returns></returns>
    public static async Task<IResult> StatusAsync(ISettingsContext settings, IUserContext users, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger("Auth");

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
        if (oauth.Enabled == true)
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

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> AuthAsync(Connection user, ISettingsContext settings, IUserContext users, HttpContext context, TokenService token, ILoggerFactory logger)
    {
        var log = logger.CreateLogger("Auth");

        var proxy = await settings.GetSettings<Proxy>(Proxy.Name);
        var oauth = await settings.GetSettings<Oauth>(Oauth.Name);
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
                fromDb = await users.TokenFromDb(userNameFromRefreshToken);
                logged = true;
                needNewRefreshToken = false;
            }
        }
        else
        {
            // Unauth call
            if (proxy?.ProxyAuth == true && proxy.Header is not null)
            {
                log.LogInformation("Connexion by header");
                (logged, fromDb) = await ProxyAuthHelper.ConnectHeader(users, context, proxy, log);
            }

            if (!logged && oauth.Enabled && user.Redirect is not null)
            {
                log.LogInformation("Logging from oauth using  {redirect}", user.Redirect);
                (logged, fromDb) = await OauthHelper.ConnectOauth(users, oauth, user, log);
            }

            // Custom auth didn't work, fall back on password
            if (!logged)
            {
                // Fallback on the password if the other means failed
                log.LogInformation("Connexion by username");
                (logged, fromDb) = await PasswordHelper.ConnectPassword(user, users, log);
            }
        }

        if (!logged || fromDb is null)
            return TypedResults.Unauthorized();

        log.LogDebug("Connexion validated");

        var accessToken = token.GetAccessToken(fromDb, DateTime.UtcNow.AddMinutes(1));
        var refreshToken = needNewRefreshToken ? token.GetRefreshToken(fromDb, DateTime.UtcNow.AddDays(30)) : string.Empty;

        return TypedResults.Ok(new TokenResponse(accessToken, refreshToken));
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
