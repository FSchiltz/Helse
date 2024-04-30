using Api.Data;
using Api.Helpers.Auth;
using Api.Models;

namespace Api.Helpers;

public static class UserHelper
{
    public static async Task CreateUserAsync(this IUserContext users, PersonCreation newUser, long userId)
    {
        // Open a transaction
        await using var transaction = await users.BeginTransactionAsync();

        // create the person
        var id = await users.InsertPerson(newUser);

        // create the user if needed
        // patient are non user of the app, only external people managed by a caregiver
        // TODO add patient account creation
        if (newUser.Type != Api.Models.UserType.Patient)
        {
            if (newUser.UserName is null)
                throw new ArgumentException("Missing username", nameof(newUser));

            if (newUser.Password is null)
                throw new ArgumentException("Missing password", nameof(newUser));

            var password = TokenService.Hash(newUser.Password);
            await users.InsertUser(newUser, id, password);
        }
        else
        {
            // we had an implicit right for the current user if needed
            await users.AddRight(userId, id, RightType.Edit);
            await users.AddRight(userId, id, RightType.View);
        }

        await transaction.CommitAsync();
    }
}