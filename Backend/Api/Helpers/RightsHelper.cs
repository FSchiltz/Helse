using System.Security.Claims;
using Api.Data;
using Api.Data.Models;
using Api.Helpers.Auth;
using Api.Models;

namespace Api.Helpers;

public static class RightsHelper
{
    /// <summary>
    /// Validate that the user is a caregiver with the correct right
    /// </summary>
    /// <param name="db"></param>
    /// <param name="user"></param>
    /// <param name="personId"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    internal static async Task<bool> ValidateCaregiverAsync(this IUserContext db, User user, long personId, RightType type)
    {
        var now = DateTime.UtcNow;
        // check if the user has the right 
        var right = await db.HasRightAsync(user.Id, personId, type, now);
        return right is not null;
    }

    internal static async Task<IResult?> IsAdmin(this IUserContext db, ClaimsPrincipal context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (user.Type.HasRight(UserType.Admin))
            return TypedResults.Forbid();

        return null;
    }

    internal static bool HasRight(this int type, Models.UserType right) => ((Models.UserType)type).HasFlag(right);

    internal static async Task<(IResult?, User)> GetUser(this IUserContext db, ClaimsPrincipal context)
    {
        // get the connected user
        var userName = context.GetUser();

        var user = await db.Get(userName);
        if (user is null)
            return (TypedResults.Unauthorized(), User.Empty);

        return (null, user.User);
    }

    public static async Task<TokenInfo?> TokenFromDb(this IUserContext db, string user)
    {
        var fromDb = await db.Get(user);

        if (fromDb is null)
            return null;

        return new TokenInfo(fromDb.User.Id, fromDb.User.Type.ToString(),
         fromDb.User.Identifier, fromDb.User.Password,
          fromDb.Person.Surname, fromDb.Person.Name,
          fromDb.User.Email);
    }
}