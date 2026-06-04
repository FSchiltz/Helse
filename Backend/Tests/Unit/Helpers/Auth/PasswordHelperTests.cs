using Api.Data;
using Api.Data.Models.Persons;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Helpers.Auth;

public class PasswordHelperTests
{
    [Fact]
    public async Task ConnectPassword_ReturnsTrue_WhenPasswordIsCorrect()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var logger = Substitute.For<ILogger<object>>();
        const string password = "TestPassword123!";
        var hash = TokenService.Hash(password);

        db.Get("testuser").Returns(new User()
        {
            Id = 1,
            Identifier = "",
            Password = hash,
            Type = 1,
        });

        var user = new Connection("testuser", password,  null, null);

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

        db.Get("testuser").Returns(new User()
        {
            Id = 1,
            Identifier = "",
            Password = hash,
            Type = 1,
        });

        var user = new Connection("testuser", wrongPassword, null, null);

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

        db.Get("unknownuser").Returns(default(User?));
        var user = new Connection("unknownuser", "password",  null, null);

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

        // Act
        await PasswordHelper.UpdatePasswordAsync(1, password, db);

        // Assert
        await db.Received(1).UpdatePassword(1, Arg.Any<string>());
    }
}
