using Api.Data.Models;
using Api.Helpers;
using Api.Models;
using LinqToDB;

namespace Api.Data;

public static class UserExtensions
{
    public static async Task CreateUserAsync(this AppDataConnection db, PersonCreation newUser, long userId)
    {
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
        if (newUser.Type != Api.Models.UserType.Patient)
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
                Type = (int)Api.Models.RightType.Edit
            });
            await db.GetTable<Data.Models.Right>().InsertAsync(() => new Data.Models.Right
            {
                UserId = userId,
                Start = DateTime.UtcNow,
                PersonId = id,
                Type = (int)Api.Models.RightType.View
            });
        }

        await transaction.CommitAsync();
    }

    public static Task ChangeRole(this AppDataConnection db, long userId, int newType)
    {
        return db.GetTable<Data.Models.User>()
        .Where(x => x.Id == userId)
        .Set(x => x.Type, newType)
        .UpdateAsync();
    }
}