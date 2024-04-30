using System.Security.Claims;

namespace Api.Helpers.Auth;

public static class TokenHelper
{
    public static string? GetUser(this ClaimsPrincipal claims, string tokenType = "access")
    {
        if(!claims.Claims.Any(x => x.Type == "token" && x.Value == tokenType))
        {
            // Wrong token type
            return null;
        }
        var claim = claims.Claims.FirstOrDefault(x => x.Type.EndsWith("nameidentifier", StringComparison.OrdinalIgnoreCase));

        return claim?.Value;
    }
}
