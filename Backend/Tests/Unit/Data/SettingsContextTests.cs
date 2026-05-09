using Api.Data;
using Api.Data.Models;
using Api.Models.Settings.Admin;
using LinqToDB;
using LinqToDB.Data;
using Xunit;

namespace Tests.Unit.Data;

public class SettingsContextTests : IAsyncLifetime
{
    private DataConnection _db = null!;

    public async Task InitializeAsync()
    {
        // Create in-memory SQLite database
        _db = new DataConnection("SQLite.MS", new LinqToDB.DataOptions().UseSQLiteMs("Data Source=:memory:"));
        await _db.CreateTableAsync<Settings>();
    }

    public async Task DisposeAsync()
    {
        if (_db != null)
            await _db.DisposeAsync();
    }

    [Fact]
    public async Task GetSettings_ReturnsDefault_WhenNotFound()
    {
        // Arrange
        var context = new SettingsContext(_db);

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
        var settings = new Oauth { Enabled = true, Url = "http://example.com", ClientId = "test-client" };
        var json = System.Text.Json.JsonSerializer.Serialize(settings);
        await _db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "oauth", Blob = json });

        var context = new SettingsContext(_db);

        // Act
        var result = await context.GetSettings<Oauth>("oauth");

        // Assert
        Assert.NotNull(result);
        Assert.True(result.Enabled);
        Assert.Equal("http://example.com", result.Url);
        Assert.Equal("test-client", result.ClientId);
    }

    [Fact]
    public async Task Upsert_InsertsNewSetting()
    {
        // Arrange
        var proxy = new Proxy { ProxyAuth = true, Header = "X-Auth" };
        var json = System.Text.Json.JsonSerializer.Serialize(proxy);
        var context = new SettingsContext(_db);

        // Act
        await context.Upsert("proxy", json);

        // Assert
        var saved = await _db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync();
        Assert.NotNull(saved);
        Assert.Equal(json, saved.Blob);
    }

    [Fact]
    public async Task Upsert_UpdatesExistingSetting()
    {
        // Arrange
        var oldSettings = new Proxy { ProxyAuth = false };
        var oldJson = System.Text.Json.JsonSerializer.Serialize(oldSettings);
        await _db.GetTable<Settings>().InsertAsync(() => new Settings { Name = "proxy", Blob = oldJson });

        var newSettings = new Proxy { ProxyAuth = true, Header = "X-Auth-New" };
        var newJson = System.Text.Json.JsonSerializer.Serialize(newSettings);
        var context = new SettingsContext(_db);

        // Act
        await context.Upsert("proxy", newJson);

        // Assert
        var saved = await _db.GetTable<Settings>().Where(s => s.Name == "proxy").FirstOrDefaultAsync();
        Assert.NotNull(saved);
        Assert.Equal(newJson, saved.Blob);
    }
}