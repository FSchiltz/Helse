using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using LinqToDB;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers;

[ApiController]
[Route("[controller]")]
public class PersonController : ControllerBase
{
    private readonly ILogger<PersonController> _logger;
    private readonly AppDataConnection _repository;

    public PersonController(AppDataConnection repository, ILogger<PersonController> logger)
    {
        _logger = logger;
        _repository = repository;
    }

    /// <summary>
    /// Create a User 
    /// Only admin role unless no user exists (App setup)
    /// </summary>
    /// <returns></returns>
    [HttpPost, AllowAnonymous]
    public async Task<ActionResult> Post([FromBody] Models.Person newUser, CancellationToken token)
    {
        // check if no user
        var userName = HttpContext.User.GetUser();

        bool userHasRole;
        if (userName is null)
        {
            userHasRole = (await _repository.GetTable<User>().LongCountAsync(token)) == 0;
        }
        else
        {
            // else check if user is admin
            var user = await _repository.GetTable<User>().Where(x => x.Identifier == userName).FirstOrDefaultAsync(token);
            userHasRole = user?.IsAdmin() == true;
        }

        if (!userHasRole)
            return Unauthorized();

        // Open a transaction
        using var transaction = await _repository.BeginTransactionAsync(token);

        // create the person
        var id = await _repository.GetTable<Person>().InsertWithInt64IdentityAsync(()
            => new Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
            }, token);

        // create the user
        await _repository.GetTable<User>().InsertAsync(()
            => new User
            {
                Identifier = newUser.UserName,
                Password = JwtHelper.Hash(newUser.Password),
                Phone = newUser.Phone,
                Email = newUser.Email,
                PersonId = id,
                Type = (int)newUser.Type,
            }, token);

        return NoContent();
    }
}
