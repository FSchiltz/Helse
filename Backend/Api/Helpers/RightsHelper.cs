using System.Security.Claims;
using Helse.Api.Data;
using Helse.Api.Data.Models.Persons;
using Helse.Api.Helpers.Auth;
using Helse.Models.Persons;

namespace Helse.Api.Helpers;

internal static class RightsHelper
{
    /// <summary>
    /// Validate that the user is a caregiver with the correct right
    /// </summary>
    /// <param name="db"></param>
    /// <param name="user"></param>
    /// <param name="personId"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    public static async Task<bool> ValidateCaregiverAsync(this IUserContext db, User user, long personId, RightType type)
    {
        var now = DateTime.UtcNow;
        // check if the user has the right 
        var right = await db.HasRightAsync(user.Id, personId, type, now);
        return right is not null;
    }

    public static async Task<IResult?> IsAdmin(this IUserContext db, ClaimsPrincipal context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (!user.HasRight(Data.Models.Persons.UserType.Admin))
            return TypedResults.Forbid();

        return null;
    }

    public static async Task<(IResult?, User)> GetUser(this IUserContext db, ClaimsPrincipal context)
    {
        // get the connected user
        var userName = context.GetUser();

        var user = await db.Get(userName);
        if (user is null)
            return (TypedResults.Unauthorized(), User.Empty);

        return (null, user);
    }

    /// <summary>
    /// Validate that the user has the correct right
    /// </summary>
    /// <param name="db"></param>
    /// <param name="personId"></param>
    /// <param name="right"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<(IResult?, long person)> ValidateUserOrCaregiver(this IUserContext db, long? personId, RightType right, ClaimsPrincipal context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return (error, 0);

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, right))
            return (TypedResults.Forbid(), 0);

        return (null, personId ?? user.PersonId);
    }
}