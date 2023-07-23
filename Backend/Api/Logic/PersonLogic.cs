using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using LinqToDB;

namespace Api.Logic;

public static class PersonLogic
{
    /// <summary>
    /// Create a User 
    /// Only admin role unless no user exists (App setup)
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> Create(Models.Person newUser, AppDataConnection db, HttpContext context)
    {
        // check if no user
        var userName = context.User.GetUser();

        bool userHasRole;
        if (userName is null)
        {
            userHasRole = (await db.GetTable<User>().LongCountAsync()) == 0;
        }
        else
        {
            // else check if user is admin
            var user = await db.GetTable<User>().Where(x => x.Identifier == userName).FirstOrDefaultAsync();
            userHasRole = user?.IsAdmin() == true;
        }

        if (!userHasRole)
            return TypedResults.Unauthorized();

        // Open a transaction
        using var transaction = await db.BeginTransactionAsync();

        // create the person
        var id = await db.GetTable<Person>().InsertWithInt64IdentityAsync(()
            => new Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
            });

        // create the user
        await db.GetTable<User>().InsertAsync(()
            => new User
            {
                Identifier = newUser.UserName,
                Password = TokenService.Hash(newUser.Password),
                Phone = newUser.Phone,
                Email = newUser.Email,
                PersonId = id,
                Type = (int)newUser.Type,
            });

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }
}
