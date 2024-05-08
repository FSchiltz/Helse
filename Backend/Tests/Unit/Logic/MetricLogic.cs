using System.Security.Claims;
using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Api.Models;
using Microsoft.AspNetCore.Http;
using NSubstitute;

public class MetricLogicTests
{
    private readonly IUserContext _users = Substitute.For<IUserContext>();
    private readonly IHealthContext _db = Substitute.For<IHealthContext>();

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
            Type = 2,
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
            Type = 2,
        }, new Api.Data.Models.Person()));

        await Assert.ThrowsAsync<System.IO.InvalidDataException>(() => MetricsLogic.CreateTypeAsync(type, _users, _db, context));
    }
}