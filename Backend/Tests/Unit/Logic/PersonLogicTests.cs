using Helse.Api.Logic;
using NSubstitute;

namespace Tests.Unit.Logic;

public class PersonLogicTests : LogicTests
{
    [Fact]
    public async Task GetAsync_ReturnsUsers_WhenAdmin()
    {
        // Arrange        
        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();

        users.GetUsers().Returns(
        [
            new(new Helse.Api.Data.Models.Persons.User { Id = 1, Identifier = "test", Password = "pass",
            Created = DateTime.Now, }, new Helse.Api.Data.Models.Persons.Person { Id = 1, Name = "Test",
            Created = DateTime.Now, })
        ]);
        users.GetRights(Arg.Any<DateTime>()).Returns([]);

        // Act
        var result = await PersonLogic.GetAsync(users, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Helse.Models.Persons.Person>>>(result);
        Assert.NotNull(okResult.Value);
    }

    [Fact]
    public async Task GetAsync_ReturnsForbid_WhenNotAdmin()
    {
        // Arrange
        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.User);
        var context = SetupContext();

        // Act
        var result = await PersonLogic.GetAsync(users, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.ForbidHttpResult>(result);
    }
}