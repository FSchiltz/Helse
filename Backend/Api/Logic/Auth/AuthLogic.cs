using Api.Data;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace Api.Logic.Auth;

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
            return TypedResults.Ok(new Status(false, false, null, null, null, false));
        }

        var isAuth = false;

        string? oauthUrl = null;
        string? oauthId = null;
        var oauth = await settings.GetSettings<Oauth>(Oauth.Name);
        if (oauth?.Enabled == true)
        {
            oauthUrl = oauth.Url;
            oauthId = oauth.ClientId;
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
        return TypedResults.Ok(new Status(true, isAuth, null, oauthUrl, oauthId, oauth?.AutoLogin ?? false));
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
            else if (oauth.Enabled && user.Redirect is not null)
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

        var accessToken = token.GetAccessToken(fromDb, DateTime.UtcNow.AddSeconds(30));
        var refreshToken = needNewRefreshToken ? token.GetRefreshToken(fromDb, DateTime.UtcNow.AddMinutes(3)) : string.Empty;

        return TypedResults.Ok(new TokenResponse(accessToken, refreshToken));
    }
}
