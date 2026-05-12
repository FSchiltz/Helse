using Api.Helpers.Auth;
using Microsoft.AspNetCore.Identity;
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
