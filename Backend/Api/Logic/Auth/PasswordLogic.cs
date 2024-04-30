using Api.Data;
using Api.Data.Models;
using Api.Helpers.Auth;
using LinqToDB;
using Microsoft.AspNetCore.Identity;

namespace Api.Logic.Auth;

public static class PasswordLogic
{
    public static async Task<(bool, TokenInfo?)> ConnectPassword(Connection user, IDataContext db, ILogger log)
    {
        // auth
        var fromDb = await db.TokenFromDb( user.User);

        if (fromDb is null)
            return (false, null);

        // generate the token
        switch (TokenService.Verify(user.Password, fromDb.Password))
        {
            case PasswordVerificationResult.Success:
                // Success, nothing to do
                break;
            case PasswordVerificationResult.SuccessRehashNeeded:
                // Success but the password needs an update
                await UpdatePasswordAsync(fromDb.Id, user.Password, db);
                break;
            case PasswordVerificationResult.Failed:
            default:
                log.LogWarning("Unauthorized access to getToken with user {user}", user.User);
                return (false, null);
        }

        return (true, fromDb);
    }

    public async static Task UpdatePasswordAsync(long user, string password, IDataContext db)
    {
        var hash = TokenService.Hash(password);

        await db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();
    }
}