using Api.Data;
using Api.Helpers.Auth;
using Api.Models.Persons;
using Api.Models.Settings;

namespace Api.Helpers;

public static class UserHelper
{
    public static async Task<(long Person, long? User)> CreateUserAsync(this IUserContext users, PersonCreation newUser, long userId)
    {
        // Open a transaction
        await using var transaction = await users.BeginTransactionAsync();

        // create the person
        var id = await users.InsertPerson(newUser);
        long? newUserId = null;

        // create the user if needed
        // patient are non user of the app, only external people managed by a caregiver
        // TODO add patient account creation
        if (newUser.Types.Any(x => x == UserType.User || x == UserType.Admin))
        {
            if (newUser.UserName is null)
                throw new ArgumentException("Missing username", nameof(newUser));

            if (newUser.Password is null)
                throw new ArgumentException("Missing password", nameof(newUser));

            var password = TokenService.Hash(newUser.Password);
            newUserId = await users.InsertUser(newUser, id, password);
        }
        else
        {
            // we had an implicit right for the current user if needed
            await users.AddRight(userId, id, RightType.Edit);
            await users.AddRight(userId, id, RightType.View);
        }

        await transaction.CommitAsync();

        return (id, newUserId);
    }
}