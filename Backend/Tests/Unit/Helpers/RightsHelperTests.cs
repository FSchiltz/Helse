using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models.Settings;
using NSubstitute;
using System.Security.Claims;

namespace Tests.Unit.Helpers;

public class RightsHelperTests
{
    [Fact]
    public async Task ValidateCaregiverAsync_ReturnsTrue_WhenUserHasRight()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User { Id = 1, Identifier = "caregiver", Password = "pass", Type = (int)UserType.Caregiver };
        var right = new Api.Models.Settings.Right { Start = DateTime.UtcNow };
        db.HasRightAsync(1, 2, RightType.View, Arg.Any<DateTime>()).Returns(right);

        // Act
        var result = await db.ValidateCaregiverAsync(user, 2, RightType.View);

        // Assert
        Assert.True(result);
    }

    [Fact]
    public async Task ValidateCaregiverAsync_ReturnsFalse_WhenUserHasNoRight()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User { Id = 1, Identifier = "caregiver", Password = "pass", Type = (int)UserType.Caregiver };
        db.HasRightAsync(1, 2, RightType.View, Arg.Any<DateTime>()).Returns((Api.Models.Settings.Right?)null);

        // Act
        var result = await db.ValidateCaregiverAsync(user, 2, RightType.View);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public async Task IsAdmin_ReturnsForbid_WhenUserIsNotAdmin()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User { Id = 1, Identifier = "user", Password = "pass", Type = (int)UserType.User };
        var person = new Person { Id = 1, Name = "Test", Surname = "User" };
        var personFromDb = new PersonFromDb(user, person);
        db.Get("testuser").Returns(personFromDb);

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "testuser")
        ]);
        var claimsPrincipal = new ClaimsPrincipal(claims);

        // Act
        var result = await db.IsAdmin(claimsPrincipal);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task IsAdmin_ReturnsUnauthorized_WhenUserNotFound()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        db.Get("unknownuser").Returns((PersonFromDb?)null);

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "unknownuser")
        ]);
        var claimsPrincipal = new ClaimsPrincipal(claims);

        // Act
        var result = await db.IsAdmin(claimsPrincipal);

        // Assert
        var unauthorizedResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.UnauthorizedHttpResult>(result);
        Assert.NotNull(unauthorizedResult);
    }

    [Fact]
    public async Task TokenFromDb_ReturnsTokenInfo_WhenUserExists()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User { Id = 1, Identifier = "testuser", Password = "pass", Type = (int)UserType.User, Email = "test@example.com" };
        var person = new Person { Id = 1, Name = "John", Surname = "Doe" };
        var personFromDb = new PersonFromDb(user, person);
        db.Get("testuser").Returns(personFromDb);

        // Act
        var result = await db.TokenFromDb("testuser");

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.Id);
        Assert.Equal("testuser", result.Identifier);
        Assert.Equal("pass", result.Password);
        Assert.Equal("John", result.Name);
        Assert.Equal("Doe", result.Surname);
        Assert.Equal("test@example.com", result.Email);
        Assert.Contains("User", result.Role);
    }

    [Fact]
    public async Task TokenFromDb_ReturnsNull_WhenUserNotFound()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        db.Get("unknownuser").Returns((PersonFromDb?)null);

        // Act
        var result = await db.TokenFromDb("unknownuser");

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task TokenFromDb_ReturnsRoleString_WhenUserHasMultipleTypes()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User { Id = 1, Identifier = "admin", Password = "pass", Type = (int)(UserType.Admin | UserType.User), Email = null };
        var person = new Person { Id = 1, Name = "Admin", Surname = "User" };
        var personFromDb = new PersonFromDb(user, person);
        db.Get("admin").Returns(personFromDb);

        // Act
        var result = await db.TokenFromDb("admin");

        // Assert
        Assert.NotNull(result);
        Assert.Contains("Admin", result.Role);
        Assert.Contains("User", result.Role);
        Assert.Contains(";", result.Role);
    }
}
