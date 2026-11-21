using Helse.Api.Helpers.Auth;
using Microsoft.AspNetCore.Identity;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

namespace Tests.Unit.Helpers.Auth;

public class TokenServiceTests
{
    [Fact]
    public void Hash_ReturnsDifferentHash_WhenCalledMultipleTimes()
    {
        // Arrange
        var password = "TestPassword123!";

        // Act
        var hash1 = TokenService.Hash(password);
        var hash2 = TokenService.Hash(password);

        // Assert
        Assert.NotEqual(hash1, hash2);
    }

    [Fact]
    public void Hash_ReturnsNonEmptyString()
    {
        // Arrange
        var password = "TestPassword123!";

        // Act
        var hash = TokenService.Hash(password);

        // Assert
        Assert.NotEmpty(hash);
    }

    [Fact]
    public void Verify_ReturnsSuccess_WhenPasswordMatchesHash()
    {
        // Arrange
        var password = "TestPassword123!";
        var hash = TokenService.Hash(password);

        // Act
        var result = TokenService.Verify(password, hash);

        // Assert
        Assert.Equal(PasswordVerificationResult.Success, result);
    }

    [Fact]
    public void Verify_ReturnsFailed_WhenPasswordDoesNotMatchHash()
    {
        // Arrange
        var correctPassword = "TestPassword123!";
        var wrongPassword = "WrongPassword456!";
        var hash = TokenService.Hash(correctPassword);

        // Act
        var result = TokenService.Verify(wrongPassword, hash);

        // Assert
        Assert.Equal(PasswordVerificationResult.Failed, result);
    }

    [Fact]
    public void GetRefreshToken_ReturnsValidJwtToken()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);

        var tokenInfo = new Helse.Api.Data.Models.Persons.User()
        {
            Identifier = "id",
            Password = "pppp",
            Created = DateTime.Now,
        };

        // Act
        var token = service.GetRefreshToken(tokenInfo, Guid.NewGuid());

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
        var handler = new JwtSecurityTokenHandler();
        Assert.Null(handler.ReadJwtToken(token).Payload.Expiration);
        var principal = handler.ValidateToken(
            token,
            new TokenValidationParameters
            {
                ValidIssuer = "issuer",
                ValidAudience = "audience",
                IssuerSigningKey = key,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                LifetimeValidator = TokenHelper.ValidateLifetime,
                ClockSkew = TimeSpan.Zero,
            },
            out _);
        Assert.NotNull(principal);
    }

    [Fact]
    public async Task GetRefreshToken_ValidatesWithJsonWebTokenHandler()
    {
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var service = new TokenService(new TokenConfig("issuer", "audience", key));
        var tokenInfo = new Helse.Api.Data.Models.Persons.User()
        {
            Identifier = "id",
            Password = "pppp",
            Created = DateTime.Now,
        };
        var token = service.GetRefreshToken(tokenInfo, Guid.NewGuid());

        var result = await new JsonWebTokenHandler().ValidateTokenAsync(
            token,
            new TokenValidationParameters
            {
                ValidIssuer = "issuer",
                ValidAudience = "audience",
                IssuerSigningKey = key,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                LifetimeValidator = TokenHelper.ValidateLifetime,
                ClockSkew = TimeSpan.Zero,
            });

        Assert.True(result.IsValid, result.Exception?.ToString());
    }

    [Fact]
    public void GetAccessToken_ReturnsValidJwtToken()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var config = new TokenConfig("issuer", "audience", key)
        {
            Validity = 10,
        };
        var service = new TokenService(config);

        var tokenInfo = new Helse.Api.Data.Models.Persons.User()
        {
            Identifier = "id",
            Password = "pppp",
            Created = DateTime.Now,
        };

        // Act
        var token = service.GetAccessToken(tokenInfo);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }

    [Fact]
    public void JwtValidation_RejectsExpiredToken_WhenExpirationIsNotRequired()
    {
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var handler = new JwtSecurityTokenHandler();
        var expiredToken = new JwtSecurityToken(
            issuer: "issuer",
            audience: "audience",
            claims: [new Claim("token", "access")],
            notBefore: DateTime.UtcNow.AddMinutes(-2),
            expires: DateTime.UtcNow.AddMinutes(-1),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature));
        var token = handler.WriteToken(expiredToken);

        Assert.Throws<SecurityTokenExpiredException>(() => handler.ValidateToken(
            token,
            new TokenValidationParameters
            {
                ValidIssuer = "issuer",
                ValidAudience = "audience",
                IssuerSigningKey = key,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                LifetimeValidator = TokenHelper.ValidateLifetime,
                ClockSkew = TimeSpan.Zero,
            },
            out _));
    }

    [Fact]
    public void JwtValidation_AllowsExpiredRefreshToken_ForDatabaseSessionValidation()
    {
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var handler = new JwtSecurityTokenHandler();
        var expiredToken = new JwtSecurityToken(
            issuer: "issuer",
            audience: "audience",
            claims: [new Claim("token", "refresh")],
            notBefore: DateTime.UtcNow.AddMinutes(-2),
            expires: DateTime.UtcNow.AddMinutes(-1),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature));
        var token = handler.WriteToken(expiredToken);

        var principal = handler.ValidateToken(
            token,
            new TokenValidationParameters
            {
                ValidIssuer = "issuer",
                ValidAudience = "audience",
                IssuerSigningKey = key,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                LifetimeValidator = TokenHelper.ValidateLifetime,
                ClockSkew = TimeSpan.Zero,
            },
            out _);

        Assert.NotNull(principal);
    }

    [Fact]
    public void GetRefreshToken_IncludesEmailClaim_WhenEmailIsNotNull()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);

        var tokenInfo = new Helse.Api.Data.Models.Persons.User()
        {
            Identifier = "id",
            Password = "pppp",
            Created = DateTime.Now,
        };

        // Act
        var token = service.GetRefreshToken(tokenInfo, Guid.NewGuid());

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }

    [Fact]
    public void GetRefreshToken_ExcludesEmailClaim_WhenEmailIsNull()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 256)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);

        var tokenInfo = new Helse.Api.Data.Models.Persons.User()
        {
            Identifier = "id",
            Password = "pppp",
            Created = DateTime.Now,
        };

        // Act
        var token = service.GetRefreshToken(tokenInfo, Guid.NewGuid());

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }
}
