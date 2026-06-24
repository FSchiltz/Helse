using Helse.Api.Data;
using Helse.Api.Data.Models.Admin;
using Helse.Models.Settings.Admin;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Async;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class SettingsContextTests(DatabaseFixture fixture) : IAsyncLifetime
{
    private DataConnection _db = null!;

    private readonly SlowQueryLogInterceptor _interceptor = new(
        Substitute.For<ILogger<SlowQueryLogInterceptor>>());

    public async ValueTask InitializeAsync()
    {
        var temp = await fixture.GetTempDB();
        _db = new DataConnection(x => new DataOptions().UsePostgreSQL(temp));
        await DatabaseFixture.InitForUnit(_db);
    }

    public async ValueTask DisposeAsync()
    {
        if (_db != null)
            await _db.DisposeAsync();
    }

    [Fact]
    public async Task GetSettings_ReturnsDefault_WhenNotFound()
    {
        // Arrange
        var context = new SettingsContext(_db, _interceptor);

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
        await _db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "oauth", Blob = json }, token: TestContext.Current.CancellationToken);

        var context = new SettingsContext(_db, _interceptor);

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
        var proxy = new Proxy { ProxyAuth = true, Header = "X-Auth" };
        var json = System.Text.Json.JsonSerializer.Serialize(proxy);
        var context = new SettingsContext(_db, _interceptor);

        // Act
        await context.Upsert("proxy", json);

        // Assert
        var saved = await _db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync(token: TestContext.Current.CancellationToken);
        Assert.NotNull(saved);
        Assert.Equal(json, saved.Blob);
    }

    [Fact]
    public async Task Upsert_UpdatesExistingSetting()
    {
        // Arrange
        var oldSettings = new Proxy { ProxyAuth = false };
        var oldJson = System.Text.Json.JsonSerializer.Serialize(oldSettings);
        await _db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "proxy", Blob = oldJson }, token: TestContext.Current.CancellationToken);

        var newSettings = new Proxy { ProxyAuth = true, Header = "X-Auth-New" };
        var newJson = System.Text.Json.JsonSerializer.Serialize(newSettings);
        var context = new SettingsContext(_db, _interceptor);

        // Act
        await context.Upsert("proxy", newJson);

        // Assert
        var saved = await _db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync(token: TestContext.Current.CancellationToken);
        Assert.NotNull(saved);
        Assert.Equal(newJson, saved.Blob);
    }
}