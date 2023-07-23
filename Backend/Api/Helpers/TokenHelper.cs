using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Api.Data.Models;
using Api.Models;

namespace Api.Helpers;

public static class TokenHelper {

    public static string? GetUser(this ClaimsPrincipal claims)
    {
        return claims.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Sub)?.Value;
    }

    public static bool IsAdmin(this User user) => user.Type == (int)UserType.User;
}
