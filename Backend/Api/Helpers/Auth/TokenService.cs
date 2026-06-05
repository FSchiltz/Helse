using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Identity;
using Api.Data.Models.Persons;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace Api.Helpers.Auth;

public record TokenConfig(string Issuer, string Audience, SymmetricSecurityKey Key);

public record TokenInfo(long Id, string Role);

public class TokenService(TokenConfig config)
{
    public static string Hash(string password)
    {
        return new PasswordHasher<User>().HashPassword(User.Empty, password);
    }

    public static PasswordVerificationResult Verify(string password, string hash)
    {
        return new PasswordHasher<User>().VerifyHashedPassword(User.Empty, hash, password);
    }

    public string GetRefreshToken(User info, DateTime expires, Guid sessionId)
    {
        var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.NameId, info.Identifier),
                new("token", "refresh"),
                new("session", sessionId.ToString()),
             };

        return GetToken(claims, expires);
    }

    public string GetAccessToken(User info, DateTime expires)
    {
        var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.NameId, info.Identifier),
                new ("token", "access"),
             };

        return GetToken(claims, expires);
    }

    private string GetToken(List<Claim> claims, DateTime expires)
    {
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = expires,
            Issuer = config.Issuer,
            Audience = config.Audience,
            SigningCredentials = new SigningCredentials(config.Key, SecurityAlgorithms.HmacSha512Signature)
        };
        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}