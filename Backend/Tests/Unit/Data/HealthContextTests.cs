using Helse.Api.Data;
using Helse.Api.Data.Models.Health;
using Helse.Api.Data.Models.Persons;
using LinqToDB;
using LinqToDB.Data;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class HealthContextTests(DatabaseFixture fixture) : IAsyncLifetime
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
    public async Task GetEventTypes_ReturnsEmpty_WhenNoneExist()
    {
        // Arrange
        var context = new HealthContext(_db, _interceptor);

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
        await _db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = "Type1",
            Description = "First type",
            StandAlone = true,
            UserEditable = true,
            Visible = true,
        }, token: TestContext.Current.CancellationToken);

        await _db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = "Type2",
            Description = "Second type",
            StandAlone = true,
            UserEditable = true,
            Visible = true,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db, _interceptor);

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
        var context = new HealthContext(_db, _interceptor);

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
        var groupid = (long)await _db.GetTable<MetricGroup>().InsertWithIdentityAsync(() => new MetricGroup()
        {
            Description = "",
            Name = "",
            ShowOnDashboard = true,
            ShowTitle = true,
        }, token: TestContext.Current.CancellationToken);

        await _db.GetTable<MetricType>().InsertAsync(() => new MetricType
        {
            Name = "HeartRate",
            Type = (int)Helse.Models.Metrics.MetricDataType.Number,
            SummaryType = (int)Helse.Models.Metrics.MetricSummary.Mean,
            Unit = 0,
            UserEditable = true,
            ShowOnDashboard = true,
            Visible = true,
            GroupId = groupid,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db, _interceptor);

        // Act
        var result = await context.GetMetricTypes(false, null);

        // Assert
        Assert.NotNull(result);
        Assert.Single(result);
        Assert.Equal("HeartRate", result[0].Name);
    }

    [Fact]
    public async Task GetMetricType_ReturnsNull_WhenNotFound()
    {
        // Arrange
        var context = new HealthContext(_db, _interceptor);

        // Act
        var result = await context.GetMetricType(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetMetricType_ReturnsMetricType_WhenFound()
    {
        // Arrange
        var groupid = (long)await _db.GetTable<MetricGroup>().InsertWithIdentityAsync(() => new MetricGroup()
        {
            Description = "",
            Name = "",
            ShowOnDashboard = true,
            ShowTitle = true,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await _db.GetTable<MetricType>().InsertWithIdentityAsync(() => new MetricType
        {
            Name = "Temperature",
            Type = (int)Helse.Models.Metrics.MetricDataType.Number,
            SummaryType = (int)Helse.Models.Metrics.MetricSummary.Mean,
            Unit = 0,
            UserEditable = true,
            Visible = true,
            ShowOnDashboard = true,
            GroupId = groupid,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db, _interceptor);

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
        var context = new HealthContext(_db, _interceptor);

        // Act
        var result = await context.GetEvent(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetEvent_ReturnsEvent_WhenFound()
    {
        var person = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "",
            Name = "",
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await _db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "",
            Password = "",
            PersonId = person,
            Created = DateTime.Now,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await _db.GetTable<Event>().InsertWithIdentityAsync(() => new Event
        {
            PersonId = person,
            UserId = user,
            Type = 1,
            Start = DateTime.UtcNow,
            Stop = DateTime.UtcNow.AddHours(1),
            Valid = true,
            SourceId = string.Empty,
            NotificationSent = false,
            Created = DateTime.Now,
            Source = 0,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(_db, _interceptor);

        // Act
        var result = await context.GetEvent(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.PersonId);
        Assert.True(result.Valid);
    }
}