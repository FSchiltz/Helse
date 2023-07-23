using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using LinqToDB;

namespace Api.Logic;

public record Connection(string User, string Password);

public static class AuthLogic
{
    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    public static async Task<IResult> Auth(Connection user, AppDataConnection db, TokenService token, ILoggerFactory logger)
    {
        // auth
        var fromDb = await db.GetTable<User>().Where(x => x.Identifier == user.User).FirstOrDefaultAsync();

        if (fromDb is null)
            return TypedResults.Unauthorized();

        // hash the password
        var hash = TokenService.Hash(user.Password);

        // generate the token
        if (hash == fromDb.Password)
        {
            return TypedResults.Ok(token.GetToken(fromDb));
        }
        else
        {
            logger.CreateLogger("Auth").LogWarning("Unauthorized access to getToken");
            return TypedResults.Unauthorized();
        }
    }
}
