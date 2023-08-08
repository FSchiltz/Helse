using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Models;
using LinqToDB;
using Microsoft.AspNetCore.Identity;

namespace Api.Logic;

/// <summary>
/// Data needed to start a connection
/// </summary>
/// <param name="User"></param>
/// <param name="Password"></param>
public record Connection(string User, string Password);

public record Status(bool Init, string? Error);

/// <summary>
/// Logic over user authentication and right
/// </summary>
public static class AuthLogic
{
    /// <summary>
    /// Return true if the server is correctly installed
    /// If false, some steps are missing:
    ///     - Missing first user
    /// </summary>
    /// <param name="db"></param>
    /// <param name="token"></param>
    /// <param name="logger"></param>
    /// <returns></returns>
    public static async Task<IResult> StatusAsync(AppDataConnection db)
    {
        var count = await db.GetTable<User>().CountAsync();
        return TypedResults.Ok(new Status(count > 0, null));
    }

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> AuthAsync(Connection user, AppDataConnection db, TokenService token, ILoggerFactory logger)
    {
        // auth
        var fromDb = await db.GetTable<User>().FirstOrDefaultAsync(x => x.Identifier == user.User);

        if (fromDb is null)
            return TypedResults.Unauthorized();

        // generate the token
        switch (TokenService.Verify(user.Password, fromDb.Password))
        {
            case PasswordVerificationResult.Success:
                // Success, nothing to do
                break;
            case PasswordVerificationResult.SuccessRehashNeeded:
                // Sucess but the password needs an update
                await UpdatePasswordAsync(fromDb.Id, user.Password, db);
                break;
            case PasswordVerificationResult.Failed:
            default:
                logger.CreateLogger("Auth").LogWarning("Unauthorized access to getToken");
                return TypedResults.Unauthorized();
        }

        return TypedResults.Ok(token.GetToken(fromDb));
    }

    public async static Task UpdatePasswordAsync(long user, string password, AppDataConnection db)
    {
        var hash = TokenService.Hash(password);

        await db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();
    }

    /// <summary>
    /// Check that a user has the given right over someone
    /// </summary>
    /// <param name="user"></param>
    /// <param name="person"></param>
    /// <param name="type"></param>
    /// <param name="time"></param>
    /// <param name="db"></param>
    /// <returns></returns>
    public async static Task<Api.Models.Right?> HasRightAsync(long user, long person, RightType type, DateTime time, AppDataConnection db)
     => (await db.GetTable<Data.Models.Right>()
        .Where(x => x.UserId == user
            && x.PersonId == person
            && x.Type == (int)type
            && x.Start <= time
            && (x.Stop == null || x.Stop >= time))
        .FirstOrDefaultAsync())?.FromDb();

    /// <summary>
    /// Validate that the user is a caregiver with the correct right
    /// </summary>
    /// <param name="db"></param>
    /// <param name="user"></param>
    /// <param name="personId"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    internal static async Task<bool> ValidateCaregiverAsync(this AppDataConnection db, Data.Models.User user, long personId, RightType type)
    {
        var now = DateTime.UtcNow;
        // check if the user has the right 
        var right = await HasRightAsync(user.Id, personId, type, now, db);
        if (right is null)
            return false;

        return true;
    }
}
