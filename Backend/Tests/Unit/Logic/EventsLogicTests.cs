using Api.Data;
using Api.Data.Models.Persons;
using Api.Logic;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;

namespace Tests.Unit.Logic;

public class EventsLogicTests : LogicTests
{
    private readonly IEventContext _db = Substitute.For<IEventContext>();

    [Fact]
    public async Task EventType_NonAdmin()
    {
        var type = new Api.Models.Events.EventType()
        {
            Name = "",
            Description = "",
            Id = 0,
            UserEditable = true,
        };

        var users = SetupUser(UserType.User);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<ForbidHttpResult>(result);
    }

    [Fact]
    public async Task EventType()
    {
        var type = new Api.Models.Events.EventType()
        {
            Name = "",
            Description = "",
            Id = 0,
            UserEditable = true,
        };

        var users = SetupUser(UserType.Admin);
        var context = SetupContext();

        var result = await EventsLogic.CreateTypeAsync(type, users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}