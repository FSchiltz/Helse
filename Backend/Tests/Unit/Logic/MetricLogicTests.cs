using System.Security.Claims;
using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Api.Models;
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
        var type = new Api.Models.MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new System.Security.Claims.ClaimsPrincipal([
                new ClaimsIdentity(),
            ])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new User
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Patient,
        }, new Api.Data.Models.Person()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task MetricType_AddTextSumAsync()
    {
        var type = new Api.Models.MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new System.Security.Claims.ClaimsPrincipal([
                new ClaimsIdentity(),
            ])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new User
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new Api.Data.Models.Person()));

        await Assert.ThrowsAsync<System.IO.InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, _users, _db, context));
    }

    [Fact]
    public async Task MetricType_AddTextMeanAsync()
    {
        var type = new Api.Models.MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Sum,
        };
        var context = new DefaultHttpContext
        {
            User = new System.Security.Claims.ClaimsPrincipal([
                new ClaimsIdentity(),
            ])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new User
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new Api.Data.Models.Person()));

        await Assert.ThrowsAsync<System.IO.InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, _users, _db, context));
    }

    [Fact]
    public async Task MetricType_Text()
    {
        var type = new Api.Models.MetricType()
        {
            Name = "",
            Type = MetricDataType.Text,
            SummaryType = MetricSummary.Latest,
        };
        var context = new DefaultHttpContext
        {
            User = new System.Security.Claims.ClaimsPrincipal([
                new ClaimsIdentity(),
            ])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new User
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new Api.Data.Models.Person()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<NoContent>(result);
    }

    [Fact]
    public async Task MetricType_Number()
    {
        var type = new Api.Models.MetricType()
        {
            Name = "",
            Type = MetricDataType.Number,
            SummaryType = MetricSummary.Mean,
        };
        var context = new DefaultHttpContext
        {
            User = new System.Security.Claims.ClaimsPrincipal([
                new ClaimsIdentity(),
            ])
        };
        _users.Get(default).ReturnsForAnyArgs(new PersonFromDb(new User
        {
            Identifier = "",
            Password = "",
            Type = (int)UserType.Admin,
        }, new Api.Data.Models.Person()));

        var result = await MetricsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}