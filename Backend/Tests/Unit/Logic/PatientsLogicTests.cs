using Api.Data;
using Api.Logic;
using Api.Models.Persons;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;

namespace Tests.Unit.Logic;

public class PatientsLogicTests : LogicTests
{
    [Fact]
    public async Task GetPatientsAsync_ReturnsPatients_WhenValidUser()
    {
        // Arrange
        var users = SetupUser(Api.Data.Models.UserType.Admin);
        var context = SetupContext();
        var db = Substitute.For<IHealthContext>();
        Api.Data.Models.Person[] persons =
        [
            new() { Id = 1, Name = "Test", Surname = "User" }
        ];
        db.GetPatients(1, Arg.Any<DateTime>(), Api.Models.Settings.RightType.View).Returns(persons);

        // Act
        var result = await PatientsLogic.GetPatientsAsync(users, db, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Person>>>(result);
        Assert.NotNull(okResult.Value);
        var patient = Assert.Single(okResult.Value);
        Assert.Equal("Test", patient.Name);
    }
}