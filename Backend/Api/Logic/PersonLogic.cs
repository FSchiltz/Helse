using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Logic.Auth;
using Api.Models;
using LinqToDB;
using LinqToDB.Data;
using Microsoft.AspNetCore.Http.HttpResults;

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
    public static async Task<IResult> GetAsync(IUserContext db, HttpContext context)
    {
        var admin = await db.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var users = await db.GetUsers(null);

        var now = DateTime.UtcNow;
        var rights = (await db.GetRights(now))
                             .GroupBy(x => x.UserId)
                             .ToDictionary(x => x.Key);

        var models = users.Select(x =>
        {
            if (x.User == null || !rights.TryGetValue(x.User.Id, out var right))
            {
                right = null;
            }

            return new Models.Person
            {
                Id = x.User?.Id ?? 0,
                Birth = x.Person.Birth,
                Name = x.Person.Name,
                Surname = x.Person.Surname,
                Identifier = x.Person.Identifier,
                UserName = x.User?.Identifier,
                Email = x.User?.Email,
                Phone = x.User?.Phone,
                Type = (UserType)(x.User?.Type ?? 0),
                Rights = right?.Select(x => x.FromDb()).ToList() ?? [],
            };
        });

        return TypedResults.Ok(models);
    }

    /// <summary>
    /// Get the list of users/person that are caregiver
    /// The caller needs to be another caregiver
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetCaregiverAsync(IUserContext db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context.User);
        if (error is not null)
            return error;

        if (((UserType)user.Type).HasFlag(UserType.Caregiver))
            return TypedResults.Unauthorized();

        var users = await db.GetUsers((int)UserType.Caregiver);

        var now = DateTime.UtcNow;

        var models = users.Select(x =>
        {
            return new Models.Person
            {
                Id = x.User?.Id ?? 0,
                UserName = x.User?.Identifier,
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
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> SetRight(long personId, List<Models.Right> rights, IUserContext users, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
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

        await using var transaction = await users.BeginTransactionAsync();

        // first we stop existing righs for the user by settings an end date
        await users.SetExpiryRight(personId, now);

        // insert the new rights
        await users.InsertRights(dbRights);

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
    public static async Task<IResult> CreateAsync(Models.PersonCreation newUser, IUserContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(PersonLogic));

        ValidateUser(newUser);

        // check if no user
        var userName = context.User.GetUser();
        var userId = 0L;

        bool userHasRole;
        if (userName is null)
        {
            userHasRole = (await db.Count()) == 0;
        }
        else
        {
            var user = await db.Get(userName);
            // else check if user is admin
            userId = user?.User.Id ?? 0;

            userHasRole = user?.User.Type.HasRight(Models.UserType.Admin) == true;

            // Care giver can add new patients without admin right
            userHasRole = userHasRole || user?.User.Type.HasRight(Models.UserType.Caregiver) == true;
        }

        if (!userHasRole)
            return TypedResults.Unauthorized();

        log.LogInformation("User creation of {user}", newUser.UserName);

        await db.CreateUserAsync(newUser, userId);

        return TypedResults.NoContent();
    }

    /// <summary>
    /// Change the role of a user
    /// Needs adim right
    /// </summary>
    /// <param name="personId"></param>
    /// <param name="role"></param>
    /// <param name="db"></param>
    /// <returns></returns>
    public static async Task<IResult> SetPersonRole(long personId, UserType role, IUserContext db, HttpContext context)
    {
        var admin = await db.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.UpdateRole(personId, (int)role);

        return TypedResults.NoContent();
    }
}
