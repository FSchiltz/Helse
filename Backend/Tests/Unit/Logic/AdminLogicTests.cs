using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Api.Models.Admin;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;

namespace Tests.Unit.Logic;

public class AdminLogicTests
{
    [Fact]
    public async Task GetUserStatsAsync_ReturnsForbidden_WhenUserIsNotAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.User,
        }, new()));

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "test")
        ]);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };

        // Act
        var result = await AdminLogic.GetUserStatsAsync(users, health, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetUserStatsAsync_ReturnsUserStats_WhenUserIsAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.Admin,
        }, new()));

        var userSummaries = new[]
        {
            new CountRecord("User", 5),
            new CountRecord("Admin", 1)
        };
        users.GetUserSumary().Returns(userSummaries);

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "admin")
        ]);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };

        // Act
        var result = await AdminLogic.GetUserStatsAsync(users, health, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<UserStats>>(result);
        Assert.NotNull(okResult.Value);
        Assert.Equal(2, okResult.Value.UserCount.Length);
    }

    [Fact]
    public async Task GetMetricStatsAsync_ReturnsForbidden_WhenUserIsNotAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.User,
        }, new()));
        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "test")
        ]);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };
        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        // Act
        var result = await AdminLogic.GetMetricStatsAsync(start, end, users, health, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetMetricStatsAsync_ReturnsMetricStats_WhenUserIsAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.Admin,
        }, new()));

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        var metricStats = new[]
        {
            new CountByDate(start, 5),
            new CountByDate(start.AddDays(1), 3)
        };
        health.GetMetricStats(start, end).Returns(metricStats);

        var metricCounts = new Dictionary<int, int> { { 1, 8 } };
        health.CountMetricsByType(start, end).Returns(metricCounts);

        var metricTypes = new List<MetricType> { new() { Id = 1, Name = "Blood Pressure" } };
        health.GetMetricTypes(true).Returns(metricTypes);

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "admin")
        ]);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };

        // Act
        var result = await AdminLogic.GetMetricStatsAsync(start, end, users, health, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<MetricStats>>(result);
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
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.Admin,
        }, new()));

        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "test")
        ]);
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };
        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        // Act
        var result = await AdminLogic.GetEventStatsAsync(start, end, users, health, context);

        // Assert
        var forbidResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
        Assert.NotNull(forbidResult);
    }

    [Fact]
    public async Task GetEventStatsAsync_ReturnsEventStats_WhenUserIsAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var health = Substitute.For<IHealthContext>();
        users.Get("admin").Returns(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)Api.Data.Models.UserType.Admin,
        }, new()));

        var start = DateTime.UtcNow.AddMonths(-1);
        var end = DateTime.UtcNow;

        var eventStats = new[]
        {
            new CountByDate(start, 10),
            new CountByDate(start.AddDays(1), 7)
        };
        health.GetEventStats(start, end).Returns(eventStats);

        var eventCounts = new Dictionary<int, int> { { 1, 17 } };
        health.CountEventsByType(start, end).Returns(eventCounts);

        var eventTypes = new List<EventType> { new() { Id = 1, Name = "Doctor Visit" } };
        health.GetEventTypes(true).Returns(eventTypes);

        var claims = new ClaimsIdentity(new[]
        {
            new Claim(ClaimTypes.NameIdentifier, "admin")
        });
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };

        // Act
        var result = await AdminLogic.GetEventStatsAsync(start, end, users, health, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<EventStats>>(result);
        Assert.NotNull(okResult.Value);
        Assert.Equal(2, okResult.Value.Events.Length);
        Assert.Single(okResult.Value.EventCounts);
        Assert.Equal("Doctor Visit", okResult.Value.EventCounts[0].Id);
        Assert.Equal(17, okResult.Value.EventCounts[0].Count);
    }
}
