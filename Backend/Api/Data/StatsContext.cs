using System.Data;
using Api.Data.Models;
using Api.Models.Admin;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

/// <inheritdoc/>
public class StatsContext(DataConnection db) : BaseContext(db), IStatsContext
{
    public Task<CountByDate[]> GetEventStats(DateTime start, DateTime end)
    {
        return Db.GetTable<Data.Models.Event>()
            .Where(x => x.Created <= end && x.Created >= start)
            .GroupBy(e => e.Created.Date)
            .Select(g => new CountByDate(g.Key, g.Count()))
            .OrderBy(s => s.Date)
            .ToArrayAsync();
    }

    public Task<Dictionary<int, int>> CountEventsByType(DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.Created <= end && x.Created >= start)
            .GroupBy(x => x.Type)
            .Select(x => new { x.Key, Count = x.Count() })
            .ToDictionaryAsync(x => x.Key, x => x.Count);
    }

    public Task<CountByDate[]> GetMetricStats(DateTime start, DateTime end)
    {
        return Db.GetTable<Data.Models.Event>()
            .Where(x => x.Created <= end && x.Created >= start)
            .GroupBy(e => e.Created.Date)
            .Select(g => new CountByDate(g.Key, g.Count()))
            .OrderBy(s => s.Date)
            .ToArrayAsync();
    }

    public Task<Dictionary<int, int>> CountMetricsByType(DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.Created <= end && x.Created >= start)
            .GroupBy(x => x.Type)
            .Select(x => new { x.Key, Count = x.Count() })
            .ToDictionaryAsync(x => x.Key, x => x.Count);
    }

    public async Task<CountRecord[]> GetUserSumary()
    {
        var query =
        from u in Db.GetTable<User>()
        from p in Db.GetTable<Person>().RightJoin(pr => pr.Id == u.PersonId)
        group u by u.Type into q
        select new { q.Key, Count = q.Count() };

        var results = await query.ToArrayAsync();
        return [.. results.Select(x => new CountRecord(((UserType)x.Key).ToString(), x.Count))];
    }
}
