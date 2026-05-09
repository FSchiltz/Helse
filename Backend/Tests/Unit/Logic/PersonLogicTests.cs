using Api.Data;
using Api.Logic;
using Api.Models.Persons;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Xunit;
using Api.Helpers;

namespace Tests.Unit.Logic;

public class PersonLogicTests
{
    [Fact]
    public async Task GetAsync_ReturnsUsers_WhenAdmin()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, Identifier = "admin", Password = "pass", Type = 1 };
        db.GetUser(Arg.Any<ClaimsPrincipal>()).Returns((null, user));
        var users = new List<PersonFromDb>
        {
            new PersonFromDb(new Api.Data.Models.User { Id = 1, Identifier = "test", Password = "pass" }, new Api.Data.Models.Person { Id = 1, Name = "Test" })
        };
        db.GetUsers().Returns(users);
        db.GetRights(Arg.Any<DateTime>()).Returns(new List<Api.Data.Models.Right>());
        var context = new DefaultHttpContext();
        context.User = new ClaimsPrincipal(new ClaimsIdentity());

        // Act
        var result = await PersonLogic.GetAsync(db, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Person>>>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task GetAsync_ReturnsForbid_WhenNotAdmin()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, Identifier = "user", Password = "pass", Type = 0 };
        db.GetUser(Arg.Any<ClaimsPrincipal>()).Returns((null, user));
        var context = new DefaultHttpContext();
        context.User = new ClaimsPrincipal(new ClaimsIdentity());

        // Act
        var result = await PersonLogic.GetAsync(db, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
    }
}