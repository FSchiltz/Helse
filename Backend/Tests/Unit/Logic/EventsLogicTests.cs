using Helse.Api.Data.Models.Persons;
using Helse.Api.Data;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;
using Helse.Api.Logic;

namespace Tests.Unit.Logic;

public class EventsLogicTests : LogicTests
{
    private readonly IEventContext _db = Substitute.For<IEventContext>();

    [Fact]
    public async Task EventType_NonAdmin()
    {
        var type = new Helse.Models.Events.CreateEventType()
        {
            Name = "",
            Description = "",
            GroupId = 1,
        };

        var users = SetupUser(UserType.User);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task EventType()
    {
        var type = new Helse.Models.Events.CreateEventType()
        {
            Name = "",
            Description = "",
            GroupId = 2,
        };

        var users = SetupUser(UserType.Admin);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}