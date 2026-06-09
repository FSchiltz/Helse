using Api.Data;
using Api.Data.Models.Persons;
using Api.Helpers;
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
        var user = new User
        {
            Id = 1,
            Identifier = "caregiver",
            Password = "pass",
            Type = (int)UserType.Caregiver,
            Created = DateTime.Now,
        };
        var right = new Api.Models.Persons.Right { Start = DateTime.UtcNow };
        db.HasRightAsync(1, 2, Api.Models.Persons.RightType.View, Arg.Any<DateTime>()).Returns(right);

        // Act
        var result = await db.ValidateCaregiverAsync(user, 2, Api.Models.Persons.RightType.View);

        // Assert
        Assert.True(result);
    }

    [Fact]
    public async Task ValidateCaregiverAsync_ReturnsFalse_WhenUserHasNoRight()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User
        {
            Id = 1,
            Identifier = "caregiver",
            Password = "pass",
            Type = (int)UserType.Caregiver,
            Created = DateTime.Now,
        };
        db.HasRightAsync(1, 2, Api.Models.Persons.RightType.View, Arg.Any<DateTime>()).Returns((Api.Models.Persons.Right?)null);

        // Act
        var result = await db.ValidateCaregiverAsync(user, 2, Api.Models.Persons.RightType.View);

        // Assert
        Assert.False(result);
    }

    [Fact]
    public async Task IsAdmin_ReturnsForbid_WhenUserIsNotAdmin()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new User
        {
            Id = 1,
            Identifier = "user",
            Password = "pass",
            Type = (int)UserType.User,
            Created = DateTime.Now,
        };
        db.Get("testuser").Returns(user);

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
        db.Get("unknownuser").Returns((User?)null);

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
}
