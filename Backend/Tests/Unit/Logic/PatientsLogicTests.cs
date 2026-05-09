using Api.Data;
using Api.Logic;
using Api.Models.Persons;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Xunit;
using Api.Helpers;

namespace Tests.Unit.Logic;

public class PatientsLogicTests
{
    [Fact]
    public async Task GetPatientsAsync_ReturnsPatients_WhenValidUser()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, Identifier = "test", Password = "pass" };
        var personFromDb = new PersonFromDb(user, new Api.Data.Models.Person { Id = 1 });
        users.Get("test").Returns(personFromDb);
        
        var db = Substitute.For<IHealthContext>();
        var persons = new List<Api.Data.Models.Person>
        {
            new() { Id = 1, Name = "Test", Surname = "User" }
        };
        db.GetPatients(1, Arg.Any<DateTime>(), Api.Models.Settings.RightType.View).Returns(persons);
        
        var claims = new ClaimsIdentity(new[]
        {
            new Claim("token", "access"),
            new Claim(ClaimTypes.NameIdentifier, "test")
        });
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };

        // Act
        var result = await PatientsLogic.GetPatientsAsync(users, db, context);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Person>>>(result);
        Assert.NotNull(okResult.Value);
        var patient = Assert.Single(okResult.Value);
        Assert.Equal("Test", patient.Name);
    }
}