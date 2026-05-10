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

        var stats = new UserStats(totalUsers, patientsCount, caregiversCount, adminsCount);
        return TypedResults.Ok(stats);
    }

    public async static Task<IResult> GetEventStatsAsync(DateTime? start, DateTime? end, IUserContext users, IHealthContext health, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var startDate = start ?? DateTime.UtcNow.AddDays(-30);
        var endDate = end ?? DateTime.UtcNow;

        // Get all events in the date range
        var events = await health.GetAllEvents(startDate, endDate);

        // Group by date and count
        var grouped = events
            .GroupBy(e => e.Start.Date)
            .Select(g => new EventDateSummary(g.Key, g.Count()))
            .OrderBy(s => s.Date)
            .ToList();

        return TypedResults.Ok(grouped);
    }
}