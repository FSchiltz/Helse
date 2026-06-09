using Api.Data;
using Api.Data.Models.Health;
using Api.Data.Models.Persons;
using LinqToDB;
using LinqToDB.Data;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class HealthContextTests(DatabaseFixture database) : IAsyncLifetime
{
    private DataConnection _db = null!;

    public async ValueTask InitializeAsync()
    {
        var temp = await database.GetTempDB();
        _db = new DataConnection(x => new DataOptions().UsePostgreSQL(temp));
        await _db.ExecuteAsync("CREATE SCHEMA health;");
        await _db.ExecuteAsync("CREATE SCHEMA person;");
        await _db.CreateTableAsync<Event>();
        await _db.CreateTableAsync<EventType>();
        await _db.CreateTableAsync<Metric>();
        await _db.CreateTableAsync<MetricType>();
        await _db.CreateTableAsync<Person>();
        await _db.CreateTableAsync<User>();
    }

    public async ValueTask DisposeAsync()
    {
        if (_db != null)
            await _db.DisposeAsync();
    }

    [Fact]
    public async Task GetEventTypes_ReturnsEmpty_WhenNoneExist()
    {
        // Arrange
        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEventTypes(false);

        // Assert
        Assert.NotNull(result);
        Assert.Empty(result);
    }

    [Fact]
    public async Task GetEventTypes_ReturnsEventTypes_WhenExist()
    {
        // Arrange
        await _db.GetTable<EventType>().InsertAsync(() => new EventType { Name = "Type1", Description = "First type" }, token: TestContext.Current.CancellationToken);
        await _db.GetTable<EventType>().InsertAsync(() => new EventType { Name = "Type2", Description = "Second type" }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEventTypes(false);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(2, result.Length);
    }

    [Fact]
    public async Task GetMetricTypes_ReturnsEmpty_WhenNoneExist()
    {
        // Arrange
        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricTypes(false, null);

        // Assert
        Assert.NotNull(result);
        Assert.Empty(result);
    }

    [Fact]
    public async Task GetMetricTypes_ReturnsMetricTypes_WhenExist()
    {
        // Arrange
        var metricType = new MetricType
        {
            Name = "HeartRate",
            Type = (int)Api.Models.Metrics.MetricDataType.Number,
            SummaryType = (int)Api.Models.Metrics.MetricSummary.Mean,
            Unit = 0,
        };
        await _db.GetTable<MetricType>().InsertAsync(() => metricType, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricTypes(false, null);

        // Assert
        Assert.NotNull(result);
        Assert.Single(result);
        Assert.Equal("HeartRate", result[0].Item.Name);
    }

    [Fact]
    public async Task GetMetricType_ReturnsNull_WhenNotFound()
    {
        // Arrange
        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricType(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetMetricType_ReturnsMetricType_WhenFound()
    {
        // Arrange
        var metricType = new MetricType
        {
            Name = "Temperature",
            Type = (int)Api.Models.Metrics.MetricDataType.Number,
            SummaryType = (int)Api.Models.Metrics.MetricSummary.Mean,
            Unit = 0,
        };
        var id = (int)await _db.GetTable<MetricType>().InsertWithIdentityAsync(() => metricType, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricType(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Temperature", result.Item.Name);
    }

    [Fact]
    public async Task GetEvent_ReturnsNull_WhenNotFound()
    {
        // Arrange
        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEvent(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetEvent_ReturnsEvent_WhenFound()
    {
        // Arrange
        var @event = new Event
        {
            PersonId = 1,
            Type = 1,
            Start = DateTime.UtcNow,
            Stop = DateTime.UtcNow.AddHours(1),
            Valid = true,
            SourceId = string.Empty,
        };
        var id = (long)await _db.GetTable<Event>().InsertWithIdentityAsync(() => @event, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEvent(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.PersonId);
        Assert.True(result.Valid);
    }
}