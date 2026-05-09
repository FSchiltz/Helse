using Api.Data;
using Api.Logic;
using Api.Models.Settings.Admin;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Api.Helpers;

namespace Tests.Unit.Logic;

public class SettingsLogicTests
{
    [Fact]
    public async Task GetOauthAsync_ReturnsOauth_WhenAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, Identifier = "admin", Password = "pass", Type = 1 };
        users.Get(Arg.Any<string>()).Returns(new PersonFromDb(user, new()));
        var settings = Substitute.For<ISettingsContext>();
        var oauth = new Oauth { Enabled = true };
        settings.GetSettings<Oauth>(Oauth.Name).Returns(oauth);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(new ClaimsIdentity())
        };

        // Act
        var result = await SettingsLogic.GetOauthAsync(users, settings, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<Oauth>>(result);
        Assert.NotNull(okResult.Value);
        Assert.True(okResult.Value.Enabled);
    }

    [Fact]
    public async Task GetOauthAsync_ReturnsForbid_WhenNotAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, Identifier = "user", Password = "pass", Type = 0 };
        users.Get(Arg.Any<string>()).Returns(new PersonFromDb(user, new()));
        var settings = Substitute.For<ISettingsContext>();
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(new ClaimsIdentity())
        };

        // Act
        var result = await SettingsLogic.GetOauthAsync(users, settings, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
    }
}