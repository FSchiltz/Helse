using Helse.Api.Data;
using Helse.Api.Mappers;

namespace Helse.Api.Logic;

/// <summary>
/// Logic over the management of common object like units
/// </summary>
internal static class CommonLogic
{
    public async static Task<IResult> GetUnitsAsync(ICommonContext db, HttpContext context)
    {
        var units = await db.GetUnitsAsync();
        return TypedResults.Ok(units.Select(x => x.ToUnit()).ToArray());
    }
}