using Helse.Api.Data;
using Helse.Api.Logic;
using Helse.Models.Admin;
using Helse.Models.Settings.Admin;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Logic;

public class AuthLogicTests
{
    [Fact]
    public async Task StatusAsync_ReturnsNotInit_WhenNoUsers()
    {
        // Arrange
        var settings = Substitute.For<ISettingsContext>();
        var users = Substitute.For<IUserContext>();
        users.Count().Returns(0);
        var context = new DefaultHttpContext();
        var loggerFactory = Substitute.For<ILoggerFactory>();

        // Act
        var result = await AuthLogic.StatusAsync(settings, users, context, loggerFactory);

        // Assert
        var statusResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<Status>>(result);
        Assert.NotNull(statusResult);
        Assert.NotNull(statusResult.Value);
        Assert.False(statusResult.Value.Init);
    }

    [Fact]
    public async Task StatusAsync_ReturnsInit_WhenUsersExist()
    {
        // Arrange
        var settings = Substitute.For<ISettingsContext>();
        var users = Substitute.For<IUserContext>();
        users.Count().Returns(1);
        var context = new DefaultHttpContext();
        var loggerFactory = Substitute.For<ILoggerFactory>();

        var oauth = new Oauth
        {
            Enabled = true,
            Providers = [ new OauthProvider() { Name = "TestProvider",
            ClaimsUrl = "",
            ClientSecret = "",
            Tokenurl = "",
             AutoRegister = true,
         Url = "http://oauth.com", ClientId = "client123", AutoLogin = true }],
        };
        settings.GetSettings<Oauth>(Oauth.Name).Returns(oauth);

        // Act
        var result = await AuthLogic.StatusAsync(settings, users, context, loggerFactory);

        // Assert
        var statusResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<Status>>(result);
        Assert.NotNull(statusResult);
        Assert.NotNull(statusResult.Value);
        Assert.True(statusResult.Value.Init);
    }

    [Fact]
    public async Task StatusAsync_ReturnsOauthDetails_WhenOauthEnabled()
    {
        // Arrange
        var settings = Substitute.For<ISettingsContext>();
        var oauth = new Oauth
        {
            Enabled = true,
            Providers = [ new OauthProvider() { Name = "TestProvider",
            ClaimsUrl = "",
            ClientSecret = "",
            Tokenurl = "",
             AutoRegister = true,
         Url = "http://oauth.com", ClientId = "client123", AutoLogin = true }],
        };
        settings.GetSettings<Oauth>(Oauth.Name).Returns(oauth);
        var users = Substitute.For<IUserContext>();
        users.Count().Returns(1);
        var context = new DefaultHttpContext();
        var loggerFactory = Substitute.For<ILoggerFactory>();

        // Act
        var result = await AuthLogic.StatusAsync(settings, users, context, loggerFactory);

        // Assert
        var statusResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<Status>>(result);
        Assert.NotNull(statusResult.Value);
        Assert.True(statusResult.Value.Init);
        Assert.Equal("http://oauth.com", statusResult.Value.Oauths[0].Url);
        Assert.Equal("client123", statusResult.Value.Oauths[0].ClientId);
        Assert.True(statusResult.Value.Oauths[0].AutoLogin);
    }
}