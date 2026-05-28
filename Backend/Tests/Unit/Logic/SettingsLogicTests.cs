using Api.Data;
using Api.Data.Models.Persons;
using Api.Logic;
using Api.Models.Settings.Admin;
using NSubstitute;

namespace Tests.Unit.Logic;

public class SettingsLogicTests : LogicTests
{
    [Fact]
    public async Task GetOauthAsync_ReturnsOauth_WhenAdmin()
    {
        // Arrange
        var users = SetupUser(UserType.Admin);
        var context = SetupContext();
        var settings = Substitute.For<ISettingsContext>();
        var oauth = new Oauth { Enabled = true };
        settings.GetSettings<Oauth>(Oauth.Name).Returns(oauth);

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
        var users = SetupUser(UserType.User);
        var context = SetupContext();
        var settings = Substitute.For<ISettingsContext>();

        // Act
        var result = await SettingsLogic.GetOauthAsync(users, settings, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
    }
}