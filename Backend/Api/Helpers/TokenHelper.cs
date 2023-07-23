using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Api.Data.Models;
using Api.Models;

namespace Api.Helpers;

public static class TokenHelper {

    public static string? GetUser(this ClaimsPrincipal claims)
    {
        var claim = claims.Claims.FirstOrDefault(x => x.Type.EndsWith("nameidentifier", StringComparison.OrdinalIgnoreCase));

        return claim?.Value;
    }
}
