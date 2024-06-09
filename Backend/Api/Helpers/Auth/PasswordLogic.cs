using Api.Data;
using Api.Models;
using Microsoft.AspNetCore.Identity;

namespace Api.Helpers.Auth;

public static class PasswordHelper
{
    public static async Task<(bool, TokenInfo?)> ConnectPassword(Connection user, IUserContext db, ILogger log)
    {
        // auth
        var fromDb = await db.TokenFromDb(user.User);

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

    public async static Task UpdatePasswordAsync(long user, string password, IUserContext db)
    {
        var hash = TokenService.Hash(password);

        await db.UpdatePassword(user, hash);
    }
}