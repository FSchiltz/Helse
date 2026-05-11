using Api.Data;
using Api.Helpers;
using Api.Models.Admin;
using Api.Models.Persons;

namespace Api.Logic;

public static class AdminLogic
{
    public async static Task<IResult> GetUserStatsAsync(IUserContext users, IHealthContext health, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var allUsers = await users.GetUsers();
        var patients = await health.GetAllPatients();

        var totalUsers = allUsers.Count;
        var patientsCount = patients.Count;
        var caregiversCount = allUsers.Count(u => u.User != null && ((UserType)u.User.Type).HasFlag(UserType.Caregiver));
        var adminsCount = allUsers.Count(u => u.User != null && ((UserType)u.User.Type).HasFlag(UserType.Admin));

        var stats = new UserStats(totalUsers, new(){
             {"Patients",patientsCount},
             {nameof(UserType.Caregiver), caregiversCount},
             {nameof(UserType.Admin ), adminsCount}});

        return TypedResults.Ok(stats);
    }

    public async static Task<IResult> GetEventStatsAsync(DateTime start, DateTime end, IUserContext users, IHealthContext health, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        // Get all events in the date range
        var events = await health.GetEventStats(start, end);

        var counts = await health.CountEventsByType(start, end);
        var eventTypes = await health.GetEventTypes(true);
        var countWithDescription = counts
            .Select(x => new { Type = eventTypes.First(t => t.Id == x.Key).Name, Count = x.Value })
            .ToDictionary(x => x.Type, x => x.Count);

        return TypedResults.Ok(new EventStats(events, countWithDescription));
    }
}