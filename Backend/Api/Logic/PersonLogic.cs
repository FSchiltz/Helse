using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using LinqToDB;

namespace Api.Logic;

public static class PersonLogic
{

    public static async Task<IResult> GetAsync(AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return TypedResults.Unauthorized();

        if (user.Type != (int)Models.UserType.Admin)
            return TypedResults.Unauthorized();

        var users = await db.GetTable<Data.Models.User>().Join(db.GetTable<Data.Models.Person>(), x => x.PersonId, x => x.Id, (u, p) => new
        {
            u,
            p
        }).ToListAsync();

        return TypedResults.Ok(users.Select(x => new Models.Person
        {
            Birth = x.p.Birth,
            Name = x.p.Name,
            Surname = x.p.Surname,
            Identifier = x.p.Identifier,
            UserName = x.u.Identifier,
            Email = x.u.Email,
            Phone = x.u.Phone,
            Type = (Api.Models.UserType)x.u.Type,


        }));
    }
    /// <summary>
    /// Create a User 
    /// Only admin role unless no user exists (App setup)
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> CreateAsync(Models.Person newUser, AppDataConnection db, HttpContext context)
    {
        if (newUser.Password == null)
            throw new ArgumentException("Missing password", nameof(newUser));

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
            var user = await db.GetTable<User>().FirstOrDefaultAsync(x => x.Identifier == userName);
            userHasRole = user?.Type == (int)Models.UserType.Admin;
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
