using Api.Data;
using Api.Models.Common;

namespace Api.Logic;

/// <summary>
/// Logic over the management of common object like units
/// </summary>
public static class CommonLogic
{
    public async static Task<IResult> GetUnitsAsync(ICommonContext db, HttpContext context)
    {
        var units = await db.GetUnitsAsync();
        return TypedResults.Ok(units.Select(x => x.ToUnit()).ToArray());
    }
}