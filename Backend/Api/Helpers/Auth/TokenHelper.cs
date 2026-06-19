using System.Security.Claims;

namespace Helse.Api.Helpers.Auth;

internal static class TokenHelper
{
    public const string Access = "access";
    public const string Refresh = "refresh";

    public static bool IsRefresh(this ClaimsPrincipal claims)
    {
        return claims.Claims.Any(x => x.Type == "token" && x.Value == Refresh);
    }

    public static string? GetUser(this ClaimsPrincipal claims, string tokenType = Access)
    {
        if (!claims.Claims.Any(x => x.Type == "token" && x.Value == tokenType))
        {
            // Wrong token type
            return null;
        }
        var claim = claims.Claims.FirstOrDefault(x => x.Type.EndsWith("nameidentifier", StringComparison.OrdinalIgnoreCase));

        return claim?.Value;
    }

    public static string? GetSession(this ClaimsPrincipal claims)
    {
        if (!claims.Claims.Any(x => x.Type == "token" && x.Value == "refresh"))
        {
            // Wrong token type
            return null;
        }
        var claim = claims.Claims.FirstOrDefault(x => x.Type.EndsWith("session", StringComparison.OrdinalIgnoreCase));
        if (claim?.Value is null)
        {
            return null;
        }

        return claim.Value;
    }
}
