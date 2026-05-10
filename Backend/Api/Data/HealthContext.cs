using System.Data;
using Api.Data.Models;
using Api.Models.Admin;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Mapping;

namespace Api.Data;

public class HealthContext(DataConnection db) : BaseContext(db), IHealthContext
{
    /// <summary>
    /// Chunked metric for the summary
    /// </summary>
    private class ChunkedMetric : Metric
    {
        [Column, NotNull]
        public int Chunk { get; set; }
    }

    private class Chunked
    {
        [Column, NotNull]
        public int Chunk { get; set; }

        [Column, NotNull]
        public DateTime Date { get; set; }

        [Column, NotNull]
        public string? Value { get; set; }
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(Api.Models.Events.CreateEvent e, long person, long user)
    {
        return Db.GetTable<Event>().InsertAsync(() => new Event
        {
            PersonId = person,
            UserId = user,
            Type = e.Type,
            Description = e.Description,
            Stop = e.Stop,
            Start = e.Start,
            Tag = e.Tag,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task DeleteEvent(long id) => Db.GetTable<Event>().DeleteAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<int> DeleteEventType(long id) => Db.GetTable<EventType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task DeleteMetric(long id) => Db.GetTable<Data.Models.Metric>().DeleteAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<int> DeleteMetricType(long id) => Db.GetTable<MetricType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Event?> GetEvent(long id) => Db.GetTable<Event>().FirstOrDefaultAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Event>> GetEvents(long id, int type, DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Event>> GetEvents(long user, Api.Models.Settings.RightType view, DateTime start, DateTime end)
    {
        return (from e in Db.GetTable<Data.Models.Event>()
                join r in Db.GetTable<Data.Models.Right>() on e.PersonId equals r.PersonId
                where e.Start <= end && start <= e.Stop
                where r.UserId == user && r.Type == (int)view
                select e)
            .ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Event>> GetEvents(long id, DateTime start, DateTime end)
    {
        return Db.GetTable<Data.Models.Event>()
            .Where(x => x.PersonId == id
                && x.TreatmentId != null
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric?> GetMetric(long id) => Db.GetTable<Metric>().FirstOrDefaultAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end)
    {
        return Db.GetTable<Data.Models.Metric>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
                                .OrderBy(x => x.Date)
            .ToArrayAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<MetricType>> GetMetricTypes(bool? all)
    {
        IQueryable<MetricType> query = Db.GetTable<MetricType>();

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<MetricType?> GetMetricType(int type) => Db.GetTable<MetricType>().FirstOrDefaultAsync(x => x.Id == type);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Person>> GetPatients(long user, DateTime now, Api.Models.Settings.RightType right)
    {
        return (from u in Db.GetTable<Person>()
                join r in Db.GetTable<Right>() on u.Id equals r.PersonId
                where r.Stop == null || (r.Stop >= now && r.Start <= now)
                where r.UserId == user
                where r.Type == (int)right
                select u).Distinct().ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Person>> GetAllPatients()
    {
        return Db.GetTable<Person>().ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<EventType>> GetEventTypes(bool? all)
    {
        IQueryable<EventType> query = Db.GetTable<EventType>();

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(EventType eventType)
    {
        return Db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = eventType.Name,
            Description = eventType.Description,
            StandAlone = eventType.StandAlone,
            UserEditable = true,
            Visible = eventType.Visible
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(MetricType metric)
    {
        return Db.GetTable<Data.Models.MetricType>().InsertAsync(() => new Data.Models.MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            Unit = metric.Unit,
            SummaryType = metric.SummaryType,
            Type = metric.Type,
            UserEditable = true,
            Visible = metric.Visible,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(Api.Models.Metrics.CreateMetric metric, long person, long user)
    {
        return Db.GetTable<Metric>().InsertAsync(() => new Metric
        {
            PersonId = person,
            Value = metric.Value,
            Date = metric.Date,
            Tag = metric.Tag,
            UserId = user,
            Type = metric.Type,
            Source = (int)metric.Source,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(EventType type)
    {
        return Db.GetTable<EventType>()
            .Where(x => x.Id == type.Id)
            .Set(x => x.Name, type.Name)
            .Set(x => x.Description, type.Description)
            .Set(x => x.Visible, type.Visible)
            .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(MetricType metric)
    {
        return Db.GetTable<MetricType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .Set(x => x.Unit, metric.Unit)
            .Set(x => x.Type, metric.Type)
            .Set(x => x.SummaryType, metric.SummaryType)
            .Set(x => x.Visible, metric.Visible)
            .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsEvent(long person, string tag) => Db.GetTable<Event>().AnyAsync(x => x.PersonId == person && x.Tag == tag);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsMetric(long person, string tag, Api.Models.FileTypes source)
    => Db.GetTable<Metric>().AnyAsync(x => x.PersonId == person && x.Tag == tag && x.Source == (int)source);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public async Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Api.Models.Metrics.MetricSummary action, DateTime start, DateTime end)
    {
        // Use a manual command to use the SQL function NTILE
        var groups = Db.FromSql<ChunkedMetric>($"SELECT NTILE({tile}) OVER (ORDER BY date) as chunk,* FROM health.metric m WHERE m.PersonId = {id} AND m.Type = {type} AND m.Date <= {end} AND m.Date >= {start}")
         .AsSubQuery()
         .GroupBy(x => x.Chunk);
        IQueryable<Chunked> query = action switch
        {
            Api.Models.Metrics.MetricSummary.Mean => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Average(y => Sql.Convert<double, string>(y.Value)).ToString(),
            }),
            Api.Models.Metrics.MetricSummary.Sum => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Sum(y => Sql.Convert<double, string>(y.Value)).ToString(),
            }),
            _ => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Min(y => y.Value),
            }),
        };
        var chunks = await query.OrderBy(x => x.Chunk)
       .ToListAsync();

        return [.. chunks.Select(x => new Metric
        {
            Date = x.Date,
            Value = x.Value ?? string.Empty,
            Tag = x.Chunk.ToString(),
        })];
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric?> GetLastMetrics(long id, int type, DateTime start, DateTime end)
    {
        return Db.GetTable<Metric>().Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
                .OrderByDescending(x => x.Date)
                .Take(1)
                .SingleOrDefaultAsync();
    }

    public Task Update(Api.Models.Metrics.UpdateMetric metric)
    {
        return Db.GetTable<Metric>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Date, metric.Date)
            .Set(x => x.Tag, metric.Tag)
            .Set(x => x.Value, metric.Value)
            .Set(x => x.Source, (int)metric.Source)
            .UpdateAsync();
    }

    public Task Update(Api.Models.Events.UpdateEvent e)
    {
        return Db.GetTable<Event>()
        .Where(x => x.Id == e.Id)
        .Set(x => x.Start, e.Start)
        .Set(x => x.Stop, e.Stop)
        .Set(x => x.Description, e.Description)
        .Set(x => x.Tag, e.Tag)
        .UpdateAsync();
    }

    public Task<EventDateSummary[]> GetEventStats(DateTime start, DateTime end)
    {
        return Db.GetTable<Data.Models.Event>()
            .Where(x => x.Start <= end && start <= x.Stop)
            .GroupBy(e => e.Start.Date)
            .Select(g => new EventDateSummary(g.Key, g.Count()))
            .OrderBy(s => s.Date)
            .ToArrayAsync();
    }
}
