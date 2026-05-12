using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;

namespace Tests.Unit.Logic;

public class EventsLogicTests : LogicTests
{
    private readonly IHealthContext _db = Substitute.For<IHealthContext>();

    [Fact]
    public async Task EventType_NonAdmin()
    {
        var type = new Api.Data.Models.EventType()
        {
            Name = "",
            Description = "",
        };

        var users = SetupUser(UserType.User);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task EventType()
    {
        var type = new Api.Data.Models.EventType()
        {
            Name = "",
            Description = "",
        };

        var users = SetupUser(UserType.Admin);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}