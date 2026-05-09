using Api.Data;
using Api.Data.Models;
using LinqToDB;
using LinqToDB.Data;
using Xunit;

namespace Tests.Unit.Data;

public class HealthContextTests : IAsyncLifetime
{
    private DataConnection _db = null!;

    public async Task InitializeAsync()
    {
        // Create in-memory SQLite database
        _db = new DataConnection("SQLite.MS", new LinqToDB.DataOptions().UseSQLiteMs("Data Source=:memory:"));
        await _db.CreateTableAsync<Event>();
        await _db.CreateTableAsync<EventType>();
        await _db.CreateTableAsync<Metric>();
        await _db.CreateTableAsync<MetricType>();
        await _db.CreateTableAsync<Person>();
        await _db.CreateTableAsync<User>();
    }

    public async Task DisposeAsync()
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
        var eventType1 = new EventType { Name = "Type1", Description = "First type" };
        var eventType2 = new EventType { Name = "Type2", Description = "Second type" };
        await _db.GetTable<EventType>().InsertAsync(() => eventType1);
        await _db.GetTable<EventType>().InsertAsync(() => eventType2);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEventTypes(false);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(2, result.Count);
    }

    [Fact]
    public async Task GetMetricTypes_ReturnsEmpty_WhenNoneExist()
    {
        // Arrange
        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricTypes(false);

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
            SummaryType = (int)Api.Models.Metrics.MetricSummary.Mean
        };
        await _db.GetTable<MetricType>().InsertAsync(() => metricType);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricTypes(false);

        // Assert
        Assert.NotNull(result);
        Assert.Single(result);
        Assert.Equal("HeartRate", result[0].Name);
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
            SummaryType = (int)Api.Models.Metrics.MetricSummary.Mean
        };
        var id = (int)(long)await _db.GetTable<MetricType>().InsertWithIdentityAsync(() => metricType);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetMetricType(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Temperature", result.Name);
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
            Valid = true
        };
        var id = (long)await _db.GetTable<Event>().InsertWithIdentityAsync(() => @event);

        var context = new HealthContext(_db);

        // Act
        var result = await context.GetEvent(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.PersonId);
        Assert.True(result.Valid);
    }
}