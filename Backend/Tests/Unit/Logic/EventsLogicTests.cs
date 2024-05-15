using System.Security.Claims;
using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using NSubstitute;

namespace Tests.Unit.Logic;

public class EventsLogicTests
{
    private readonly IUserContext _users = Substitute.For<IUserContext>();
    private readonly IHealthContext _db = Substitute.For<IHealthContext>();

    [Fact]
    public async Task EventType_NonAdmin()
    {
        var type = new Api.Data.Models.EventType()
        {
            Name = "",
            Description = "",
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

        var result = await EventsLogic.CreateTypeAsync(type, _users, _db, context);
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

        var result = await EventsLogic.CreateTypeAsync(type, _users, _db, context);
        Assert.IsType<NoContent>(result);
    }
}