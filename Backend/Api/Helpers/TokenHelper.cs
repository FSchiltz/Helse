using System.Security.Claims;

namespace Api.Helpers;

public static class TokenHelper {

    public static string? GetUser(this ClaimsPrincipal claims)
    {
        var claim = claims.Claims.FirstOrDefault(x => x.Type.EndsWith("nameidentifier", StringComparison.OrdinalIgnoreCase));

        return claim?.Value;
    }
}
