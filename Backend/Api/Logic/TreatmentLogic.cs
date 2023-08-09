using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using Api.Models;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Logic;

/// <summary>
/// Management of the users and rights
/// </summary>
public static class TreatmentLogic
{
    public async static Task<IResult> GetAsync(AppDataConnection db, HttpContext context)
    { // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return TypedResults.Unauthorized();

        var treatments = await db.GetTable<Api.Data.Models.Treatment>().Where(x => x.PersonId == user.PersonId).ToListAsync();

        return TypedResults.Ok();
    }
}