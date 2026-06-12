using Api.Data;
using Api.Data.Models.Common;
using Api.Data.Models.Health;
using Api.Data.Models.Persons;
using Api.Logic;
using Api.Models.Admin;
using Api.Models.Common;
using NSubstitute;

namespace Tests.Unit.Logic;

public class AdminLogicTests : LogicTests
{
    [Fact]
    public async Task GetUserStatsAsync_ReturnsForbidden_WhenUserIsNotAdmin()
    {
        // Arrange
        var stats = Substitute.For<IStatsContext>();
        var users = SetupUser(UserType.User);
        var context = SetupContext();

        // Act
        var result = await AdminLogic.GetUserStatsAsync(users, stats, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetUserStatsAsync_ReturnsUserStats_WhenUserIsAdmin()
    {
        // Arrange
        var stats = Substitute.For<IStatsContext>();
        var users = SetupUser(UserType.Admin);
        var context = SetupContext();
        var userSummaries = new[]
        {
            new CountRecord("User", 5),
            new CountRecord("Admin", 1)
        };
        stats.GetUserSumary().Returns(userSummaries);

        // Act
        var result = await AdminLogic.GetUserStatsAsync(users, stats, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<UserCreationStats>>(result);
        Assert.NotNull(okResult.Value);
        Assert.Equal(2, okResult.Value.UserCount.Length);
    }

    [Fact]
    public async Task GetMetricStatsAsync_ReturnsForbidden_WhenUserIsNotAdmin()
    {
        // Arrange
        var metrics = Substitute.For<IMetricContext>();
        var stats = Substitute.For<IStatsContext>();
        var users = SetupUser(UserType.User);
        var context = SetupContext();

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        // Act
        var result = await AdminLogic.GetMetricStatsAsync(start, end, users, metrics, stats, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetMetricStatsAsync_ReturnsMetricStats_WhenUserIsAdmin()
    {
        // Arrange
        var users = SetupUser(UserType.Admin);
        var context = SetupContext();
        var health = Substitute.For<IMetricContext>();
        var stats = Substitute.For<IStatsContext>();

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        var metricStats = new[]
        {
            new CountByDate(start, 5),
            new CountByDate(start.AddDays(1), 3)
        };
        stats.GetMetricStats(start, end).Returns(metricStats);

        var metricCounts = new Dictionary<long, int> { { 1, 8 } };
        stats.CountMetricsByType(start, end).Returns(metricCounts);

        MetricType[] metricTypes = [
            new() {
                Id = 1,
                Name = "Blood Pressure",
                Unit = 0,
            },
        ];
        health.GetMetricTypes(true, null).Returns(metricTypes);

        // Act
        var result = await AdminLogic.GetMetricStatsAsync(start, end, users, health, stats, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<MetricCreationStats>>(result);
        Assert.NotNull(okResult.Value);
        Assert.Equal(2, okResult.Value.Events.Length);
        Assert.Single(okResult.Value.EventCounts);
        Assert.Equal("Blood Pressure", okResult.Value.EventCounts[0].Id);
        Assert.Equal(8, okResult.Value.EventCounts[0].Count);
    }

    [Fact]
    public async Task GetEventStatsAsync_ReturnsForbidden_WhenUserIsNotAdmin()
    {
        // Arrange
        var health = Substitute.For<IEventContext>();
        var stats = Substitute.For<IStatsContext>();
        var users = SetupUser(UserType.User);
        var context = SetupContext();

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        // Act
        var result = await AdminLogic.GetEventStatsAsync(start, end, users, health, stats, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetEventStatsAsync_ReturnsEventStats_WhenUserIsAdmin()
    {
        // Arrange
        var users = SetupUser(UserType.Admin);
        var context = SetupContext();
        var health = Substitute.For<IEventContext>();
        var stats = Substitute.For<IStatsContext>();

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        var eventStats = new[]
        {
            new CountByDate(start, 10),
            new CountByDate(start.AddDays(1), 7)
        };
        stats.GetEventStats(start, end).Returns(eventStats);

        var eventCounts = new Dictionary<int, int> { { 1, 17 } };
        stats.CountEventsByType(start, end).Returns(eventCounts);

        EventType[] eventTypes = [new() { Id = 1, Name = "Doctor Visit" }];
        health.GetEventTypes(true).Returns(eventTypes);

        // Act
        var result = await AdminLogic.GetEventStatsAsync(start, end, users, health, stats, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<EventCreationStats>>(result);
        Assert.NotNull(okResult.Value);
        Assert.Equal(2, okResult.Value.Events.Length);
        Assert.Single(okResult.Value.EventCounts);
        Assert.Equal("Doctor Visit", okResult.Value.EventCounts[0].Id);
        Assert.Equal(17, okResult.Value.EventCounts[0].Count);
    }
}
