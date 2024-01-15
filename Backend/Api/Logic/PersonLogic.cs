using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Models;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Logic;

/// <summary>
/// Management of the users and rights
/// </summary>
public static class PersonLogic
{
    /// <summary>
    /// Get the list of users/person with their rights
    /// The caller needs to be an admin
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetAsync(AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        var users = await (from u in db.GetTable<Data.Models.User>()
                           from p in db.GetTable<Data.Models.Person>().RightJoin(pr => pr.Id == u.PersonId)
                           select new
                           {
                               u,
                               p,
                           }).ToListAsync();

        var now = DateTime.UtcNow;
        var rights = (await (from r in db.GetTable<Data.Models.Right>()
                             where r.Stop == null || r.Stop >= now && r.Start <= now
                             select r)
                             .ToListAsync())
                             .GroupBy(x => x.UserId)
                             .ToDictionary(x => x.Key);

        var models = users.Select(x =>
        {
            if (x.u == null || !rights.TryGetValue(x.u.Id, out var right))
            {
                right = null;
            }

            return new Models.Person
            {
                Birth = x.p.Birth,
                Name = x.p.Name,
                Surname = x.p.Surname,
                Identifier = x.p.Identifier,
                UserName = x.u?.Identifier,
                Email = x.u?.Email,
                Phone = x.u?.Phone,
                Type = (Api.Models.UserType)(x.u?.Type ?? 0),
                Rights = right?.Select(x => x.FromDb()).ToList() ?? new List<Models.Right>(),
            };
        });

        return TypedResults.Ok(models);
    }

    /// <summary>
    /// Replace the rights of an user with a new list
    /// The caller needs to be an admin
    /// </summary>
    /// <param name="personId"></param>
    /// <param name="rights"></param>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> SetRight(long personId, List<Models.Right> rights, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        var now = DateTime.UtcNow;

        // first we clean up the rights from the caller
        // the start date can't be in the past and the user must be the one in the query
        var dbRights = rights.Select(x => new Data.Models.Right
        {
            Stop = x.Stop,
            UserId = x.UserId,
            Type = (int)x.Type,
            PersonId = personId,
            Start = now > x.Start ? now : x.Start,
        });

        using var transaction = await db.BeginTransactionAsync();

        // first we stop existing righs for the user by settings an enddate
        await db.GetTable<Data.Models.Right>()
        .Where(x => x.UserId == personId)
        .Set(x => x.Stop, now)
        .UpdateAsync();

        // insert the new rights
        await db.GetTable<Data.Models.Right>().BulkCopyAsync(dbRights);

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    private static void ValidateUser(Models.PersonCreation user)
    {
        // validate Patient
        if (user.Name == null)
            throw new ArgumentException("Missing name", nameof(user));

        // validate other user
        if (user.Type == UserType.Patient)
            return;

        if (user.Password == null)
            throw new ArgumentException("Missing password", nameof(user));
    }

    /// <summary>
    /// Create a User 
    /// Only admin role unless no user exists (App setup) or caregiver if the new person is only a patient(no connection)
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> CreateAsync(Models.PersonCreation newUser, AppDataConnection db, HttpContext context)
    {
        ValidateUser(newUser);

        // check if no user
        var userName = context.User.GetUser();
        var userId = 0L;

        bool userHasRole;
        if (userName is null)
        {
            userHasRole = (await db.GetTable<User>().LongCountAsync()) == 0;
        }
        else
        {
            // else check if user is admin
            var user = await db.GetTable<User>().FirstOrDefaultAsync(x => x.Identifier == userName);
            userId = user?.Id ?? 0;

            userHasRole = user?.Type == (int)Models.UserType.Admin;

            // Care giver can add new patients without admin right
            userHasRole = userHasRole || (newUser.Type == Models.UserType.Patient && user?.Type == (int)Models.UserType.Caregiver);
        }

        if (!userHasRole)
            return TypedResults.Unauthorized();

        // Open a transaction
        using var transaction = await db.BeginTransactionAsync();

        // create the person
        var id = await db.GetTable<Data.Models.Person>().InsertWithInt64IdentityAsync(()
            => new Data.Models.Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
            });

        // create the user if needed
        // patient are non user of the app, only external people managed by a caregiver
        // TODO add patient account creation
        if (newUser.Type != Models.UserType.Patient)
        {
            if (newUser.UserName is null)
                throw new ArgumentException("Missing username", nameof(newUser));

            if (newUser.Password is null)
                throw new ArgumentException("Missing password", nameof(newUser));

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
        }
        else
        {
            // we had an implicit right for the current user if needed
            await db.GetTable<Data.Models.Right>().InsertAsync(() => new Data.Models.Right
            {
                UserId = userId,
                Start = DateTime.UtcNow,
                PersonId = id,
                Type = (int)Models.RightType.Edit
            });
            await db.GetTable<Data.Models.Right>().InsertAsync(() => new Data.Models.Right
            {
                UserId = userId,
                Start = DateTime.UtcNow,
                PersonId = id,
                Type = (int)Models.RightType.View
            });
        }

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }
}
