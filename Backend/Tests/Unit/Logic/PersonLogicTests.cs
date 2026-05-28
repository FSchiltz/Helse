using Api.Data;
using Api.Logic;
using Api.Models.Persons;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Api.Helpers;
using Api.Data.Models.Persons;

namespace Tests.Unit.Logic;

public class PersonLogicTests : LogicTests
{
    [Fact]
    public async Task GetAsync_ReturnsUsers_WhenAdmin()
    {
        // Arrange        
        var users = SetupUser(Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();

        users.GetUsers().Returns(
        [
            new(new Api.Data.Models.User { Id = 1, Identifier = "test", Password = "pass" }, new Api.Data.Models.Person { Id = 1, Name = "Test" })
        ]);
        users.GetRights(Arg.Any<DateTime>()).Returns([]);

        // Act
        var result = await PersonLogic.GetAsync(users, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Person>>>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task GetAsync_ReturnsForbid_WhenNotAdmin()
    {
        // Arrange
        var users = SetupUser(Api.Data.Models.Persons.UserType.User);
        var context = SetupContext();

        // Act
        var result = await PersonLogic.GetAsync(users, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
    }
}