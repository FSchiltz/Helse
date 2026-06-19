using Helse.Api.Data;
using Helse.Models.Treatments;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Helse.Api.Data.Models.Health;
using Helse.Models.Persons;
using Helse.Api.Logic;

namespace Tests.Unit.Logic;

public class TreatmentLogicTests
{
    [Fact]
    public async Task GetTypeAsync_ReturnsEventTypes()
    {
        // Arrange
        var db = Substitute.For<IEventContext>();
        EventType[] types =
        [
            new() { Id = 1, Name = "Test", StandAlone = true }
        ];
        db.GetEventTypes(false, true).Returns(types);

        // Act
        var result = await TreatmentLogic.GetTypeAsync(db);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<EventType[]>>(result);
        Assert.NotNull(okResult.Value);
        var type = Assert.Single(okResult.Value);
        Assert.Equal("Test", type.Name);
    }

    [Fact]
    public async Task PostAsync_ReturnsNoContent_WhenValid()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new Helse.Api.Data.Models.Persons.User
        {
            Id = 1,
            PersonId = 1,
            Identifier = "test",
            Password = "pass",
            Created = DateTime.Now,
        };
        db.Get(Arg.Any<string>()).Returns(user);
        db.BeginTransactionAsync().Returns(Substitute.For<ITransaction>());
        db.HasRightAsync(1, 1, RightType.Edit, Arg.Any<DateTime>()).Returns(new Helse.Models.Persons.Right());
        db.InsertTreatment(1, TreatmentType.Care).Returns(1L);
        var treatment = new CreateTreatment { PersonId = 1, Events = [] };
        var context = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(new ClaimsIdentity())
        };

        // Act
        var result = await TreatmentLogic.PostAsync(treatment, db, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.NoContent>(result);
    }
}