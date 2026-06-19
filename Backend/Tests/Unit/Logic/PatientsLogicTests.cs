using Helse.Api.Data;
using Helse.Api.Logic;
using Helse.Models.Persons;
using NSubstitute;

namespace Tests.Unit.Logic;

public class PatientsLogicTests : LogicTests
{
    [Fact]
    public async Task GetPatientsAsync_ReturnsPatients_WhenValidUser()
    {
        // Arrange
        var users = SetupUser(Helse.Api.Data.Models.Persons.UserType.Admin);
        var context = SetupContext();
        var db = Substitute.For<IHealthContext>();
        Helse.Api.Data.Models.Persons.Person[] persons =
        [
            new() { Id = 1, Name = "Test", Surname = "User",
            Created = DateTime.Now,}
        ];
        db.GetPatients(1, Arg.Any<DateTime>(), RightType.View).Returns(persons);

        // Act
        var result = await PatientsLogic.GetPatientsAsync(users, db, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Person>>>(result);
        Assert.NotNull(okResult.Value);
        var patient = Assert.Single(okResult.Value);
        Assert.Equal("Test", patient.Name);
    }
}