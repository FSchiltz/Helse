using Api.Data;
using Api.Data.Models;
using Api.Logic;
using Api.Models.Treatments;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;
using Xunit;
using Api.Helpers;

namespace Tests.Unit.Logic;

public class TreatmentLogicTests
{
    [Fact]
    public async Task GetTypeAsync_ReturnsEventTypes()
    {
        // Arrange
        var db = Substitute.For<IHealthContext>();
        var types = new List<EventType>
        {
            new EventType { Id = 1, Name = "Test" }
        };
        db.GetEventTypes(false).Returns(types);

        // Act
        var result = await TreatmentLogic.GetTypeAsync(db);

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<List<EventType>>>(result);
        Assert.NotNull(okResult.Value);
        var type = Assert.Single(okResult.Value);
        Assert.Equal("Test", type.Name);
    }

    [Fact]
    public async Task PostAsync_ReturnsNoContent_WhenValid()
    {
        // Arrange
        var db = Substitute.For<IUserContext>();
        var user = new Api.Data.Models.User { Id = 1, PersonId = 1, Identifier = "test", Password = "pass" };
        db.GetUser(Arg.Any<ClaimsPrincipal>()).Returns((null, user));
        db.HasRightAsync(1, 1, Api.Models.Settings.RightType.Edit, Arg.Any<DateTime>()).Returns(new Api.Models.Settings.Right());
        db.InsertTreatment(1, TreatmentType.Care).Returns(1L);
        var treatment = new CreateTreatment { PersonId = 1, Events = new List<Api.Models.Events.CreateEvent>() };
        var context = new DefaultHttpContext();
        context.User = new ClaimsPrincipal(new ClaimsIdentity());

        // Act
        var result = await TreatmentLogic.PostAsync(treatment, db, context);

        // Assert
        Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.NoContent>(result);
    }
}