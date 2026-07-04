using System.Net;
using Helse.Api.Data;
using Helse.Api.Mappers;
using Helse.Models.Common;

namespace Helse.Api.Logic;

/// <summary>
/// Logic over the management of common object like units
/// </summary>
internal static class CommonLogic
{
    public static RouteGroupBuilder MapCommon(this RouteGroupBuilder api)
    {
        api.MapGet("/units", GetUnitsAsync)
        .RequireAuthorization()
        .Produces<Unit[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    public async static Task<IResult> GetUnitsAsync(ICommonContext db, HttpContext context)
    {
        var units = await db.GetUnitsAsync();
        return TypedResults.Ok(units.Select(x => x.ToUnit()).ToArray());
    }
}