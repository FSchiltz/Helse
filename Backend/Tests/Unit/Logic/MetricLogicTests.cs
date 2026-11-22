using Helse.Api.Data;
using Helse.Api.Logic;
using Helse.Models.Metrics;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;

namespace Tests.Unit.Logic;

public class MetricLogicTests : LogicTests
{
    private readonly IMetricContext _db = Substitute.For<IMetricContext>();

    [Fact]
    public async Task MetricType_NonAdmin()
    {
        var type = new CreateMetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
            GroupId = 1,
            Unit = 0,
        };

        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.User);
        var context = SetupContext();

        var result = await MetricsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task MetricType_AddTextSumAsync()
    {
        var type = new CreateMetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
            GroupId = 1,
            Unit = 0,
        };

        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();

        await Assert.ThrowsAsync<InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, users, _db, context));
    }

    [Fact]
    public async Task MetricType_AddTextMeanAsync()
    {
        var type = new CreateMetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
            GroupId = 1,
            Unit = 0,
        };

        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();

        await Assert.ThrowsAsync<InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, users, _db, context));
    }

    [Fact]
    public async Task MetricType_Text_ReturnsCreatedId()
    {
        var type = new CreateMetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Latest,
            GroupId = 1,
            Unit = 0,
        };

        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();
        _db.Insert(type).Returns(42L);

        var result = await MetricsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.Equal(42L, Assert.IsType<Created<long>>(result).Value);
    }

    [Fact]
    public async Task MetricType_Number_ReturnsCreatedId()
    {
        var type = new CreateMetricType()
        {
            Name = "",
            Type = MetricDataType.Number,
            SummaryType = MetricSummary.Mean,
            GroupId = 1,
            Unit = 0,
        };

        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();
        _db.Insert(type).Returns(43L);

        var result = await MetricsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.Equal(43L, Assert.IsType<Created<long>>(result).Value);
    }
}