using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Identity;
using Api.Data.Models;

namespace Api.Helpers.Auth;

public record TokenInfo(long Id, string Role, string Identifier, string Password, string? Surname, string? Name, string? Email);

public class TokenService(string issuer, string audience, SymmetricSecurityKey key)
{
    private readonly string _issuer = issuer;
    private readonly string _audience = audience;
    private readonly SymmetricSecurityKey _key = key;

    public static string Hash(string password)
    {
        return new PasswordHasher<User>().HashPassword(User.Empty, password);
    }

    public static PasswordVerificationResult Verify(string password, string hash)
    {
        return new PasswordHasher<User>().VerifyHashedPassword(User.Empty, hash, password);
    }

    public string GetRefreshToken(TokenInfo info, DateTime expires)
    {
        var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.NameId, info.Identifier),
                new("roles", info.Role),
                new("surname", info.Surname ?? string.Empty),
                new("name", info.Name ?? string.Empty),
                new("token", "refresh"),
             };

        if (info.Email != null)
        {
            claims.Add(
            new Claim(JwtRegisteredClaimNames.Email, info.Email));
        }
        return GetToken(claims, expires);
    }

    public string GetAccessToken(TokenInfo info, DateTime expires)
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
            Issuer = _issuer,
            Audience = _audience,
            SigningCredentials = new SigningCredentials(_key, SecurityAlgorithms.HmacSha512Signature)
        };
        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}