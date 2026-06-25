using Helse.Api.Data;
using Helse.Api.Data.Models.Admin;
using Helse.Models.Settings.Admin;
using LinqToDB;
using LinqToDB.Async;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class SettingsContextTests(DatabaseFixture fixture) : ContextTests(fixture)
{
    [Fact]
    public async Task GetSettings_ReturnsDefault_WhenNotFound()
    {
        // Arrange
        var db = await GetDb();
        var context = new SettingsContext(db, _interceptor);

        // Act
        var result = await context.GetSettings<Oauth>("non-existent");

        // Assert
        Assert.NotNull(result);
        Assert.False(result.Enabled);
    }

    [Fact]
    public async Task GetSettings_ReturnsSettings_WhenFound()
    {
        // Arrange
        var db = await GetDb();
        var settings = new Oauth
        {
            Enabled = true,
            Providers = [ new OauthProvider()
            {
                Url = "http://example.com",
                ClientId = "test-client",
                ClaimsUrl = "",
                Name = "TestProvider",
                AutoRegister = false,
                ClientSecret = "",
                Tokenurl = "",
                }],
        };
        var json = System.Text.Json.JsonSerializer.Serialize(settings);
        await db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "oauth", Blob = json }, token: TestContext.Current.CancellationToken);

        var context = new SettingsContext(db, _interceptor);

        // Act
        var result = await context.GetSettings<Oauth>("oauth");

        // Assert
        Assert.NotNull(result);
        Assert.True(result.Enabled);
        Assert.Equal("http://example.com", result.Providers[0].Url);
        Assert.Equal("test-client", result.Providers[0].ClientId);
    }

    [Fact]
    public async Task Upsert_InsertsNewSetting()
    {
        // Arrange
        var db = await GetDb();
        var proxy = new Proxy { ProxyAuth = true, Header = "X-Auth" };
        var json = System.Text.Json.JsonSerializer.Serialize(proxy);
        var context = new SettingsContext(db, _interceptor);

        // Act
        await context.Upsert("proxy", json);

        // Assert
        var saved = await db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync(token: TestContext.Current.CancellationToken);
        Assert.NotNull(saved);
        Assert.Equal(json, saved.Blob);
    }

    [Fact]
    public async Task Upsert_UpdatesExistingSetting()
    {
        // Arrange
        var db = await GetDb();
        var oldSettings = new Proxy { ProxyAuth = false };
        var oldJson = System.Text.Json.JsonSerializer.Serialize(oldSettings);
        await db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "proxy", Blob = oldJson }, token: TestContext.Current.CancellationToken);

        var newSettings = new Proxy { ProxyAuth = true, Header = "X-Auth-New" };
        var newJson = System.Text.Json.JsonSerializer.Serialize(newSettings);
        var context = new SettingsContext(db, _interceptor);

        // Act
        await context.Upsert("proxy", newJson);

        // Assert
        var saved = await db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync(token: TestContext.Current.CancellationToken);
        Assert.NotNull(saved);
        Assert.Equal(newJson, saved.Blob);
    }
}