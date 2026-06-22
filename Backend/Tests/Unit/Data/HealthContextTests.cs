using Helse.Api.Data;
using Helse.Api.Data.Models.Health;
using Helse.Api.Data.Models.Persons;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Mapping;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class HealthContextTests(DatabaseFixture fixture)
{
    private readonly SlowQueryLogInterceptor _interceptor = new(
        Substitute.For<ILogger<SlowQueryLogInterceptor>>());

    public async Task<DataConnection> GetDb()
    {
        var temp = await fixture.GetTempDB();
        var db = new DataConnection(x =>
        {
            var mapper = new MappingSchema();
            mapper.SetConverter<DateTime, DateTime>(x => DateTime.SpecifyKind(x, DateTimeKind.Utc));

            return new DataOptions().UsePostgreSQL(temp).UseMappingSchema(mapper);
        });
        await DatabaseFixture.InitForUnit(db);
        return db;
    }

    [Fact]
    public async Task GetEventTypes_ReturnsEmpty_WhenNoneExist()
    {
        // Arrange
        await using var db = await GetDb();
        var context = new HealthContext(db, _interceptor);

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
        await using var db = await GetDb();
        await db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = "Type1",
            Description = "First type",
            StandAlone = true,
            UserEditable = true,
            Visible = true,
            GroupId = 1
        }, token: TestContext.Current.CancellationToken);

        await db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = "Type2",
            Description = "Second type",
            StandAlone = true,
            UserEditable = true,
            Visible = true,
            GroupId = 1
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(db, _interceptor);

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
        await using var db = await GetDb();
        var context = new HealthContext(db, _interceptor);

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
        await using var db = await GetDb();
        var groupid = (long)await db.GetTable<MetricGroup>().InsertWithIdentityAsync(() => new MetricGroup()
        {
            Description = "",
            Name = "",
            ShowOnDashboard = true,
            ShowTitle = true,
        }, token: TestContext.Current.CancellationToken);

        await db.GetTable<MetricType>().InsertAsync(() => new MetricType
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

        var context = new HealthContext(db, _interceptor);

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
        await using var db = await GetDb();
        var context = new HealthContext(db, _interceptor);

        // Act
        var result = await context.GetMetricType(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetMetricType_ReturnsMetricType_WhenFound()
    {
        // Arrange
        await using var db = await GetDb();
        var groupid = (long)await db.GetTable<MetricGroup>().InsertWithIdentityAsync(() => new MetricGroup()
        {
            Description = "",
            Name = "",
            ShowOnDashboard = true,
            ShowTitle = true,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<MetricType>().InsertWithIdentityAsync(() => new MetricType
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

        var context = new HealthContext(db, _interceptor);

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
        await using var db = await GetDb();
        var context = new HealthContext(db, _interceptor);

        // Act
        var result = await context.GetEvent(999);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task GetEvent_ReturnsEvent_WhenFound()
    {
        await using var db = await GetDb();
        var person = (long)await db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "",
            Name = "",
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "",
            Password = "",
            PersonId = person,
            Created = DateTime.Now,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<Event>().InsertWithIdentityAsync(() => new Event
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

        var context = new HealthContext(db, _interceptor);

        // Act
        var result = await context.GetEvent(id);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(1, result.PersonId);
        Assert.True(result.Valid);
    }

    [Fact]
    public async Task InsertEvent()
    {
        // Arrange
        await using var db = await GetDb();
        var person = (long)await db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "person",
            Name = "Person",
            Created = DateTime.UtcNow,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "user",
            Password = "pwd",
            PersonId = person,
            Created = DateTime.UtcNow,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var start = DateTime.UtcNow;
        var stop = start.AddHours(1);

        var model = new Helse.Models.Events.CreateEvent
        {
            Type = 5,
            Description = "Test event",
            Start = start,
            Stop = stop,
            Tag = "tag",
            SourceId = "source-id",
        };

        var context = new HealthContext(db, _interceptor);

        // Act
        await context.Insert(model, person, user);

        // Assert
        var evt = await db.GetTable<Event>()
            .OrderByDescending(x => x.Id)
            .FirstAsync(token: TestContext.Current.CancellationToken);

        Assert.Equal(person, evt.PersonId);
        Assert.Equal(user, evt.UserId);
        Assert.Equal(model.Type, evt.Type);
        Assert.Equal(model.Description, evt.Description);
        Assert.Equal(model.Start.Truncate(), evt.Start);
        Assert.Equal(model.Stop.Truncate(), evt.Stop);
        Assert.Equal(model.Tag, evt.Tag);
        Assert.Equal(model.SourceId, evt.SourceId);
    }

    [Fact]
    public async Task InsertEventType()
    {
        // Arrange
        await using var db = await GetDb();
        var model = new Helse.Models.Events.CreateEventType
        {
            Name = "Medication",
            Description = "Medication event",
            StandAlone = true,
            Visible = true,
            TimeDifference = TimeSpan.Zero,
            GroupId = 1,
        };

        var context = new HealthContext(db, _interceptor);

        // Act
        await context.Insert(model);

        // Assert
        var eventType = await db.GetTable<EventType>()
            .OrderByDescending(x => x.Id)
            .FirstAsync(token: TestContext.Current.CancellationToken);

        Assert.Equal(model.Name, eventType.Name);
        Assert.Equal(model.Description, eventType.Description);
        Assert.Equal(model.StandAlone, eventType.StandAlone);
        Assert.Equal(model.Visible, eventType.Visible);
        Assert.Equal(model.TimeDifference, eventType.TimeDifference);

        Assert.True(eventType.UserEditable);
    }

    [Fact]
    public async Task InsertMetricType()
    {
        // Arrange
        await using var db = await GetDb();
        var groupId = (long)await db.GetTable<MetricGroup>()
            .InsertWithIdentityAsync(() => new MetricGroup
            {
                Name = "Vitals",
                Description = "Vitals",
                ShowOnDashboard = true,
                ShowTitle = true,
            }, token: TestContext.Current.CancellationToken);

        var model = new Helse.Models.Metrics.CreateMetricType
        {
            Name = "Heart Rate",
            Description = "Heart rate",
            GroupId = groupId,
            Unit = 0,
            Type = Helse.Models.Metrics.MetricDataType.Number,
            SummaryType = Helse.Models.Metrics.MetricSummary.Mean,
            Visible = true,
            ShowOnDashboard = true,
            ValueCount = 1,
        };

        var context = new HealthContext(db, _interceptor);

        // Act
        await context.Insert(model);

        // Assert
        var metricType = await db.GetTable<MetricType>()
            .OrderByDescending(x => x.Id)
            .FirstAsync(token: TestContext.Current.CancellationToken);

        Assert.Equal(model.Name, metricType.Name);
        Assert.Equal(model.Description, metricType.Description);
        Assert.Equal(groupId, metricType.GroupId);
        Assert.Equal(model.Visible, metricType.Visible);
        Assert.Equal(model.ShowOnDashboard, metricType.ShowOnDashboard);

        Assert.True(metricType.UserEditable);
    }

    [Fact]
    public async Task InsertMetric()
    {
        // Arrange
        await using var db = await GetDb();
        var person = (long)await db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "person",
            Name = "Person",
            Created = DateTime.UtcNow,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "user",
            Password = "pwd",
            PersonId = person,
            Created = DateTime.UtcNow,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var metricTypeId = (long)await db.GetTable<MetricType>()
            .InsertWithIdentityAsync(() => new MetricType
            {
                Name = "Weight",
                Type = (int)Helse.Models.Metrics.MetricDataType.Number,
                SummaryType = (int)Helse.Models.Metrics.MetricSummary.Mean,
                Unit = 0,
                UserEditable = true,
                Visible = true,
                ShowOnDashboard = true,
                GroupId = 1,
            }, token: TestContext.Current.CancellationToken);

        var date = DateTime.UtcNow;

        var model = new Helse.Models.Metrics.CreateMetric
        {
            Type = metricTypeId,
            Value = "80",
            Date = date,
            Tag = "Morning",
            SourceId = "source-id",
        };

        var context = new HealthContext(db, _interceptor);

        // Act
        await context.Insert(model, person, user);

        // Assert
        var metric = await db.GetTable<Metric>()
            .OrderByDescending(x => x.Id)
            .FirstAsync(token: TestContext.Current.CancellationToken);

        Assert.Equal(person, metric.PersonId);
        Assert.Equal(user, metric.UserId);
        Assert.Equal(metricTypeId, metric.Type);
        Assert.Equal(model.Value, metric.Value);
        Assert.Equal(model.Date.Truncate(), metric.Date);
        Assert.Equal(model.Tag, metric.Tag);
        Assert.Equal(model.SourceId, metric.SourceId);
    }

    [Fact]
    public async Task InsertMetricGroup()
    {
        // Arrange
        await using var db = await GetDb();
        var model = new Helse.Models.Metrics.CreateGroup
        {
            Name = "Vitals",
            Description = "Vital measurements",
            ShowOnDashboard = true,
            ShowTitle = true,
        };

        var context = new HealthContext(db, _interceptor);

        // Act
        await context.Insert(model);

        // Assert
        var group = await db.GetTable<MetricGroup>()
            .OrderByDescending(x => x.Id)
            .FirstAsync(token: TestContext.Current.CancellationToken);

        Assert.Equal(model.Name, group.Name);
        Assert.Equal(model.Description, group.Description);
        Assert.Equal(model.ShowOnDashboard, group.ShowOnDashboard);
        Assert.Equal(model.ShowTitle, group.ShowTitle);
    }

    [Fact]
    public async Task UpdateEventType()
    {
        // Arrange
        await using var db = await GetDb();
        var groupId = (long)await db.GetTable<MetricGroup>()
          .InsertWithIdentityAsync(() => new MetricGroup
          {
              Name = "Group",
              Description = "",
              ShowOnDashboard = true,
              ShowTitle = true,
          }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<EventType>().InsertWithIdentityAsync(() => new EventType
        {
            Name = "Old",
            Description = "Old Description",
            StandAlone = true,
            UserEditable = true,
            Visible = true,
            GroupId = groupId,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(db, _interceptor);

        var update = new Helse.Models.Events.UpdateEventType
        {
            Id = id,
            Name = "New",
            Description = "New Description",
            Visible = false,
            TimeDifference = TimeSpan.Zero,
            GroupId = groupId,
        };

        // Act
        await context.Update(update);

        // Assert
        var result = await db.GetTable<EventType>()
            .FirstAsync(x => x.Id == id, token: TestContext.Current.CancellationToken);

        Assert.Equal("New", result.Name);
        Assert.Equal("New Description", result.Description);
        Assert.False(result.Visible);
        Assert.Equal(TimeSpan.Zero, result.TimeDifference);
        Assert.Equal(groupId, result.GroupId);
    }

    [Fact]
    public async Task UpdateMetricType()
    {
        // Arrange
        await using var db = await GetDb();
        var groupId = (long)await db.GetTable<MetricGroup>()
            .InsertWithIdentityAsync(() => new MetricGroup
            {
                Name = "Group",
                Description = "",
                ShowOnDashboard = true,
                ShowTitle = true,
            }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<MetricType>()
            .InsertWithIdentityAsync(() => new MetricType
            {
                Name = "Old",
                Description = "Old Description",
                Unit = 0,
                Type = (int)Helse.Models.Metrics.MetricDataType.Number,
                SummaryType = (int)Helse.Models.Metrics.MetricSummary.Mean,
                UserEditable = true,
                Visible = true,
                ShowOnDashboard = true,
                GroupId = groupId,
            }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(db, _interceptor);

        var update = new Helse.Models.Metrics.UpdateMetricType
        {
            Id = id,
            Name = "Weight",
            Description = "Weight metric",
            Unit = 1,
            Type = Helse.Models.Metrics.MetricDataType.Bool,
            SummaryType = Helse.Models.Metrics.MetricSummary.Mean,
            Visible = false,
            ShowOnDashboard = false,
            GroupId = groupId,
            ValueCount = 2,
            TimeDifference = TimeSpan.Zero,
        };

        // Act
        await context.Update(update);

        // Assert
        var result = await db.GetTable<MetricType>()
            .FirstAsync(x => x.Id == id, token: TestContext.Current.CancellationToken);

        Assert.Equal(update.Name, result.Name);
        Assert.Equal(update.Description, result.Description);
        Assert.Equal(update.Unit, result.Unit);
        Assert.Equal((long)update.Type, result.Type);
        Assert.Equal((long)update.SummaryType, result.SummaryType);
        Assert.Equal(update.Visible, result.Visible);
        Assert.Equal(update.ShowOnDashboard, result.ShowOnDashboard);
        Assert.Equal(update.ValueCount, result.ValueCount);
        Assert.Equal(update.TimeDifference, result.TimeDifference);
    }

    [Fact]
    public async Task UpdateMetric_UpdatesMetric()
    {
        // Arrange
        await using var db = await GetDb();
        var person = (long)await db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "",
            Name = "",
            Created = DateTime.UtcNow,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "",
            Password = "",
            PersonId = person,
            Created = DateTime.UtcNow,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<Metric>().InsertWithIdentityAsync(() => new Metric
        {
            PersonId = person,
            UserId = user,
            Type = 1,
            Value = "70",
            Date = DateTime.UtcNow,
            Source = 0,
            SourceId = "old",
            Created = DateTime.UtcNow,

        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(db, _interceptor);

        var update = new Helse.Models.Metrics.UpdateMetric
        {
            Id = id,
            Value = "80",
            Date = DateTime.UtcNow.AddDays(1),
            Tag = "Updated",
            SourceId = "new-source",
            Type = 1
        };

        // Act
        await context.Update(update);

        // Assert
        var result = await db.GetTable<Metric>()
            .FirstAsync(x => x.Id == id, token: TestContext.Current.CancellationToken);

        Assert.Equal(update.Value, result.Value);
        Assert.Equal(update.Date.Truncate(), result.Date);
        Assert.Equal(update.Tag, result.Tag);
        Assert.Equal(update.SourceId, result.SourceId);
    }

    [Fact]
    public async Task UpdateEvent_UpdatesEvent()
    {
        // Arrange
        await using var db = await GetDb();
        var person = (long)await db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Identifier = "",
            Name = "",
            Created = DateTime.UtcNow,
        }, token: TestContext.Current.CancellationToken);

        var user = (long)await db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            Identifier = "",
            Password = "",
            PersonId = person,
            Created = DateTime.UtcNow,
            Type = 1,
        }, token: TestContext.Current.CancellationToken);

        var id = (long)await db.GetTable<Event>().InsertWithIdentityAsync(() => new Event
        {
            PersonId = person,
            UserId = user,
            Type = 1,
            Start = DateTime.UtcNow,
            Stop = DateTime.UtcNow.AddHours(1),
            Valid = true,
            Source = 0,
            SourceId = "old",
            NotificationSent = false,
            Created = DateTime.UtcNow,
        }, token: TestContext.Current.CancellationToken);

        var context = new HealthContext(db, _interceptor);

        var update = new Helse.Models.Events.UpdateEvent
        {
            Id = id,
            Start = DateTime.UtcNow.AddDays(1),
            Stop = DateTime.UtcNow.AddDays(1).AddHours(2),
            Description = "Updated event",
            Tag = "Updated",
            NotificationTime = DateTime.UtcNow.AddHours(12),
            SourceId = "new-source",
            Type = 1,
        };

        // Act
        await context.Update(update);

        // Assert
        var result = await db.GetTable<Event>()
            .FirstAsync(x => x.Id == id, token: TestContext.Current.CancellationToken);

        Assert.Equal(update.Start.Truncate(), result.Start);
        Assert.Equal(update.Stop.Truncate(), result.Stop);
        Assert.Equal(update.Description, result.Description);
        Assert.Equal(update.Tag, result.Tag);
        Assert.Equal(update.NotificationTime?.Truncate(), result.NotificationTime);
        Assert.Equal(update.SourceId, result.SourceId);
    }
}