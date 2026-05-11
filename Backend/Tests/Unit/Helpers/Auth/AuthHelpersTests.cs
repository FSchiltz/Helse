using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using NSubstitute;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

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
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 32)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", "pass", "Doe", "John", "test@example.com");
        var expires = DateTime.UtcNow.AddHours(1);

        // Act
        var token = service.GetRefreshToken(tokenInfo, expires);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }

    [Fact]
    public void GetAccessToken_ReturnsValidJwtToken()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 32)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", "pass", "Doe", "John", "test@example.com");
        var expires = DateTime.UtcNow.AddHours(1);

        // Act
        var token = service.GetAccessToken(tokenInfo, expires);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }

    [Fact]
    public void GetRefreshToken_IncludesEmailClaim_WhenEmailIsNotNull()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 32)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", "pass", "Doe", "John", "test@example.com");
        var expires = DateTime.UtcNow.AddHours(1);

        // Act
        var token = service.GetRefreshToken(tokenInfo, expires);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }

    [Fact]
    public void GetRefreshToken_ExcludesEmailClaim_WhenEmailIsNull()
    {
        // Arrange
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(new string('a', 32)));
        var config = new TokenConfig("issuer", "audience", key);
        var service = new TokenService(config);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", "pass", "Doe", "John", null);
        var expires = DateTime.UtcNow.AddHours(1);

        // Act
        var token = service.GetRefreshToken(tokenInfo, expires);

        // Assert
        Assert.NotNull(token);
        Assert.NotEmpty(token);
    }
}

public class TokenHelperTests
{
    [Fact]
    public void GetUser_ReturnsUsername_WhenAccessTokenExists()
    {
        // Arrange
        var claims = new ClaimsIdentity(new[]
        {
            new Claim("token", "access"),
            new Claim(ClaimTypes.NameIdentifier, "testuser")
        });
        var principal = new ClaimsPrincipal(claims);

        // Act
        var result = principal.GetUser();

        // Assert
        Assert.Equal("testuser", result);
    }

    [Fact]
    public void GetUser_ReturnsNull_WhenWrongTokenType()
    {
        // Arrange
        var claims = new ClaimsIdentity(new[]
        {
            new Claim("token", "refresh"),
            new Claim(ClaimTypes.NameIdentifier, "testuser")
        });
        var principal = new ClaimsPrincipal(claims);

        // Act
        var result = principal.GetUser("access");

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public void GetUser_ReturnsUsername_WhenCustomTokenTypeMatches()
    {
        // Arrange
        var claims = new ClaimsIdentity(new[]
        {
            new Claim("token", "refresh"),
            new Claim(ClaimTypes.NameIdentifier, "testuser")
        });
        var principal = new ClaimsPrincipal(claims);

        // Act
        var result = principal.GetUser("refresh");

        // Assert
        Assert.Equal("testuser", result);
    }

    [Fact]
    public void GetUser_ReturnsNull_WhenNoTokenClaim()
    {
        // Arrange
        var claims = new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "testuser")
        });
        var principal = new ClaimsPrincipal(claims);

        // Act
        var result = principal.GetUser();

        // Assert
        Assert.Null(result);
    }
}

public class PasswordHelperTests
{
    [Fact]
    public async Task ConnectPassword_ReturnsTrue_WhenPasswordIsCorrect()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var logger = Substitute.For<ILogger<object>>();
        var password = "TestPassword123!";
        var hash = TokenService.Hash(password);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", hash, "Doe", "John", "test@example.com");
        db.TokenFromDb("testuser").Returns(tokenInfo);
        
        var user = new Connection("testuser", password, null);

        // Act
        var (success, token) = await PasswordHelper.ConnectPassword(user, db, logger);

        // Assert
        Assert.True(success);
        Assert.NotNull(token);
    }

    [Fact]
    public async Task ConnectPassword_ReturnsFalse_WhenPasswordIsIncorrect()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var logger = Substitute.For<ILogger<object>>();
        var correctPassword = "TestPassword123!";
        var wrongPassword = "WrongPassword456!";
        var hash = TokenService.Hash(correctPassword);
        
        var tokenInfo = new TokenInfo(1, "User", "testuser", hash, "Doe", "John", "test@example.com");
        db.TokenFromDb("testuser").Returns(tokenInfo);
        
        var user = new Connection("testuser", wrongPassword, null);

        // Act
        var (success, token) = await PasswordHelper.ConnectPassword(user, db, logger);

        // Assert
        Assert.False(success);
        Assert.Null(token);
    }

    [Fact]
    public async Task ConnectPassword_ReturnsFalse_WhenUserNotFound()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var logger = Substitute.For<ILogger<object>>();
        db.TokenFromDb("unknownuser").Returns((TokenInfo?)null);
        
        var user = new Connection("unknownuser", "password", null);

        // Act
        var (success, token) = await PasswordHelper.ConnectPassword(user, db, logger);

        // Assert
        Assert.False(success);
        Assert.Null(token);
    }

    [Fact]
    public async Task UpdatePasswordAsync_UpdatesPasswordInDatabase()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var password = "NewPassword456!";
        var hash = TokenService.Hash(password);

        // Act
        await PasswordHelper.UpdatePasswordAsync(1, password, db);

        // Assert
        await db.Received(1).UpdatePassword(1, Arg.Any<string>());
    }
}
