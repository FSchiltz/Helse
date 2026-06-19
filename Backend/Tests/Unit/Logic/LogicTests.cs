using Helse.Api.Data;
using Helse.Api.Data.Models.Persons;
using Microsoft.AspNetCore.Http;
using NSubstitute;
using System.Security.Claims;

namespace Tests.Unit.Logic;

public abstract class LogicTests
{
    protected static DefaultHttpContext SetupContext()
    {
        var claims = new ClaimsIdentity(
        [
            new Claim(ClaimTypes.NameIdentifier, "test"),
            new Claim("token", "access"),
        ]);

        return new DefaultHttpContext
        {
            User = new ClaimsPrincipal(claims)
        };
    }

    internal static IUserContext SetupUser(UserType user)
    {
        var users = Substitute.For<IUserContext>();
        users.Get("test").Returns(new User()
        {
            Id = 1,
            Identifier = "",
            Password = "",
            Type = (int)user,
            Created = DateTime.Now,
        });

        return users;
    }
}
