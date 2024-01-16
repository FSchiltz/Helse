using System.Security.Cryptography;
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

public record Status(bool Init, bool ExternalAuth, string? Error);

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
    public static async Task<IResult> StatusAsync(AppDataConnection db, HttpContext context)
    {
        // check if the server is already init
        var count = await db.GetTable<User>().CountAsync();

        if (count == 0)
            return TypedResults.Ok(new Status(false, false, null));

        var isAuth = false;
        // now we check if the user is already auth
        var settings = await db.GetSetting<Proxy>(Proxy.Name);
        if (settings?.ProxyAuth == true && settings.Header is not null && context.Request.Headers.TryGetValue(settings.Header, out var headers))
        {
            var header = headers.FirstOrDefault();
            if (header is not null)
            {
                var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == header);
                if (user is null)
                {
                    if (settings.AutoRegister)
                    {
                        // If auto register and not found, we create it
                        await db.CreateUserAsync(new PersonCreation
                        {
                            UserName = header,
                            Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                            Type = UserType.User
                        }, 0);
                        isAuth = true;
                    }
                }
                else
                    isAuth = true;

            }
        }

        return TypedResults.Ok(new Status(true, isAuth, null));
    }

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> AuthAsync(Connection user, AppDataConnection db, HttpContext context, TokenService token, ILoggerFactory logger)
    {
        var proxyAuth = false;
        var username = user.User;
        var settings = await db.GetSetting<Proxy>(Proxy.Name);

        if (settings?.ProxyAuth == true && settings.Header is not null && context.Request.Headers.TryGetValue(settings.Header, out var headers))
        {
            var header = headers.FirstOrDefault();
            if (header is not null)
            {
                // connection with the proxy header
                username = header;
                proxyAuth = true;
            }
        }

        // auth
        var fromDb = await (from u in db.GetTable<User>()
                            join p in db.GetTable<Data.Models.Person>() on u.PersonId equals p.Id
                            where u.Identifier == username
                            select new { u, p })
                            .FirstOrDefaultAsync();

        if (fromDb is null)
            return TypedResults.Unauthorized();

        var passwordStatus = proxyAuth ? PasswordVerificationResult.Success : TokenService.Verify(user.Password, fromDb.u.Password);

        // generate the token
        switch (passwordStatus)
        {
            case PasswordVerificationResult.Success:
                // Success, nothing to do
                break;
            case PasswordVerificationResult.SuccessRehashNeeded:
                // Success but the password needs an update
                await UpdatePasswordAsync(fromDb.u.Id, user.Password, db);
                break;
            case PasswordVerificationResult.Failed:
            default:
                logger.CreateLogger("Auth").LogWarning("Unauthorized access to getToken");
                return TypedResults.Unauthorized();
        }

        return TypedResults.Ok(token.GetToken(fromDb.u, fromDb.p));
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
        return right is not null;
    }

    internal static async Task<IResult?> IsAdmin(this AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (user.Type != (int)Models.UserType.Admin)
            return TypedResults.Forbid();

        return null;
    }

    internal static async Task<(IResult?, User)> GetUser(this AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return (TypedResults.Unauthorized(), User.Empty);

        return (null, user);
    }
}
