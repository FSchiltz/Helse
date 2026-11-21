using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Identity;
using Helse.Api.Data.Models.Persons;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace Helse.Api.Helpers.Auth;

internal record TokenConfig(string Issuer, string Audience, SymmetricSecurityKey Key)
{
    public long Validity { get; init; }

    public long RefreshValidity { get; init; }

    public long KeepAliveRefreshValidity { get; init; }
}

internal record TokenInfo(long Id, string Role);

internal class TokenService(TokenConfig config)
{
    public static string Hash(string password)
    {
        return new PasswordHasher<User>().HashPassword(User.Empty, password);
    }

    public static PasswordVerificationResult Verify(string password, string hash)
    {
        return new PasswordHasher<User>().VerifyHashedPassword(User.Empty, hash, password);
    }

    public DateTime TokenValidity(bool longLife = false, bool keepConnected = false)
    {
        if (longLife)
        {
            var duration = config.RefreshValidity;
            if (keepConnected)
            {
                duration = config.KeepAliveRefreshValidity;
            }

            return DateTime.UtcNow.AddMinutes(duration);
        }

        return DateTime.UtcNow.AddMinutes(config.Validity);
    }

    public string GetRefreshToken(User info, Guid sessionId)
    {
        var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.NameId, info.Identifier),
                new("token", "refresh"),
                new("session", sessionId.ToString()),
             };

        return GetToken(claims, null);
    }

    public string GetAccessToken(User info)
    {
        var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.NameId, info.Identifier),
                new ("token", "access"),
             };

        return GetToken(claims, TokenValidity());
    }

    private string GetToken(List<Claim> claims, DateTime? expires)
    {
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = expires,
            Issuer = config.Issuer,
            Audience = config.Audience,
            SigningCredentials = new SigningCredentials(config.Key, SecurityAlgorithms.HmacSha512Signature)
        };
        var tokenHandler = new JwtSecurityTokenHandler
        {
            SetDefaultTimesOnTokenCreation = expires is not null,
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}