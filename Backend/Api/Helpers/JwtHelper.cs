using System.Security.Claims;
using Api.Data.Models;
using Microsoft.IdentityModel.JsonWebTokens;
using Api.Models;

namespace Api.Helpers;

public static class JwtHelper
{
    public static string? GetUser(this ClaimsPrincipal claims)
    {
        return claims.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Sub)?.Value;
    }

    public static bool IsAdmin(this User user) => user.Type == (int)UserType.User;

    internal static string Hash(string password)
    {
        return password + "test";
    }
}