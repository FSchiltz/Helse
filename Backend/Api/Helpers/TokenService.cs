using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Identity;
using Api.Data.Models;

namespace Api.Helpers;

public class TokenService
{
    private readonly string _issuer;
    private readonly string _audience;
    private readonly SymmetricSecurityKey _key;

    public TokenService(string issuer, string audience, SymmetricSecurityKey key)
    {
        _issuer = issuer;
        _audience = audience;
        _key = key;
    }

    public static string Hash(string password)
    {
        return new PasswordHasher<User>().HashPassword(User.Empty, password);
    }

    public static PasswordVerificationResult Verify(string password, string hash)
    {
        return new PasswordHasher<User>().VerifyHashedPassword(User.Empty, hash, password);
    }

    public string GetToken(User user, Person person)
    {
        var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.NameId, user.Identifier),
                new Claim("roles", user.Type.ToString()),
                new Claim("surname", person.Surname ?? string.Empty),
                new Claim("name", person.Name ?? string.Empty),
             };

        if (user.Email != null)
        {
            claims.Add(
            new Claim(JwtRegisteredClaimNames.Email, user.Email));
        }

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddMinutes(30),
            Issuer = _issuer,
            Audience = _audience,
            SigningCredentials = new SigningCredentials(_key, SecurityAlgorithms.HmacSha512Signature)
        };
        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}