using Api.Data;
using Api.Logic;
using Api.Models.Metrics;
using Api.Models.Persons;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;

namespace Tests.Unit.Logic;

public class MetricLogicTests
{
    private readonly IUserContext _users = Substitute.For<IUserContext>();
    private readonly IHealthContext _db = Substitute.For<IHealthContext>();

    [Fact]
    public async Task MetricType_NonAdmin()
    {
        var type = new MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new([new()])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = 0,
        }, new()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task MetricType_AddTextSumAsync()
    {
        var type = new MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new([new()])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new()));

        await Assert.ThrowsAsync<InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, _users, _db, context));
    }

    [Fact]
    public async Task MetricType_AddTextMeanAsync()
    {
        var type = new MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new([new()])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new()));

        await Assert.ThrowsAsync<InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, _users, _db, context));
    }

    [Fact]
    public async Task MetricType_Text()
    {
        var type = new MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Latest,
        };
        var context = new DefaultHttpContext
        {
            User = new([new()])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<NoContent>(result);
    }

    [Fact]
    public async Task MetricType_Number()
    {
        var type = new MetricType()
        {
            Name = "",
            Type = MetricDataType.Number,
            SummaryType = MetricSummary.Mean,
        };
        var context = new DefaultHttpContext
        {
            User = new([new()])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new()
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}