using Helse.Api.Helpers;
using Helse.Api.Helpers.Auth;
using System.Security.Claims;

namespace Tests.Unit.Helpers.Auth;

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
