using Api.Data;
using Api.Helpers;
using Api.Models.Admin;
using Api.Models.Common;

namespace Api.Logic;

public static class AdminLogic
{
    public async static Task<IResult> GetUserStatsAsync(IUserContext users, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var allUsers = await stats.GetUserSumary();

        return TypedResults.Ok(new UserCreationStats(allUsers));
    }


    public async static Task<IResult> GetMetricStatsAsync(DateTime start, DateTime end, IUserContext users, IHealthContext health, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        // Get all events in the date range
        var events = await stats.GetMetricStats(start, end);

        var counts = await stats.CountMetricsByType(start, end);
        var types = await health.GetMetricTypes(true, null);
        var countWithDescription = counts
            .Select(x => new CountRecord(types.First(t => t.Id == x.Key).Name, x.Value))
            .ToArray();

        return TypedResults.Ok(new MetricCreationStats(events, countWithDescription));
    }

    public async static Task<IResult> GetEventStatsAsync(DateTime start, DateTime end, IUserContext users, IHealthContext health, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        // Get all events in the date range
        var events = await stats.GetEventStats(start, end);

        var counts = await stats.CountEventsByType(start, end);
        var eventTypes = await health.GetEventTypes(true);
        var countWithDescription = counts
            .Select(x => new CountRecord(eventTypes.First(t => t.Id == x.Key).Name, x.Value))
            .ToArray();

        return TypedResults.Ok(new EventCreationStats(events, countWithDescription));
    }
}