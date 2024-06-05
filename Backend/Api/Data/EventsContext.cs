using System.Data;
using System.Reflection.Metadata;
using Api.Data.Models;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Mapping;
using Microsoft.Data.SqlClient;

namespace Api.Data;

public interface IHealthContext : IContext
{
    Task Insert(Api.Models.CreateEvent e, long person, long user);
    Task<Event?> GetEvent(long id);
    Task<List<Event>> GetEvents(long id, int type, DateTime start, DateTime end);

    Task DeleteEvent(long id);
    Task<List<EventType>> GetEventTypes(bool? all);
    Task Insert(EventType metric);
    Task Update(EventType type);
    Task<int> DeleteEventType(long id);
    Task<List<MetricType>> GetMetricTypes(bool? all);
    Task<int> DeleteMetricType(long id);
    Task Update(MetricType metric);
    Task Insert(MetricType metric);
    Task DeleteMetric(long id);
    Task<Metric?> GetMetric(long id);
    Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end);
    Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Api.Models.MetricSummary action, DateTime start, DateTime end);
    Task Insert(Api.Models.CreateMetric metric, long v, long id);
    Task<List<Person>> GetPatients(long id, DateTime now, Api.Models.RightType view);
    Task<List<Event>> GetEvents(long id, Api.Models.RightType view, DateTime start, DateTime end);
    Task<List<Event>> GetEvents(long id, DateTime start, DateTime end);
    Task<bool> ExistsEvent(long person, string tag);
    Task<bool> ExistsMetric(long person, string tag, Api.Models.FileTypes source);

    /// <summary>
    /// Get a single metric type
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    Task<MetricType?> GetMetricType(int type);

    /// <summary>
    /// Get the last metric in the given time frame if any
    /// </summary>
    /// <param name="id"></param>
    /// <param name="type"></param>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<Metric?> GetLastMetrics(long id, int type, DateTime start, DateTime end);
}

public class HealthContext(DataConnection db) : IHealthContext
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
    public Task<DataConnectionTransaction> BeginTransactionAsync() => db.BeginTransactionAsync();

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(Api.Models.CreateEvent e, long person, long user)
    {
        return db.GetTable<Event>().InsertAsync(() => new Event
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
    public Task DeleteEvent(long id) => db.GetTable<Event>().DeleteAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<int> DeleteEventType(long id) => db.GetTable<EventType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task DeleteMetric(long id) => db.GetTable<Data.Models.Metric>().DeleteAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<int> DeleteMetricType(long id) => db.GetTable<MetricType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Event?> GetEvent(long id) => db.GetTable<Event>().FirstOrDefaultAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Event>> GetEvents(long id, int type, DateTime start, DateTime end)
    {
        return db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Event>> GetEvents(long user, Api.Models.RightType view, DateTime start, DateTime end)
    {
        return (from e in db.GetTable<Data.Models.Event>()
                join r in db.GetTable<Data.Models.Right>() on e.PersonId equals r.PersonId
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
        return db.GetTable<Data.Models.Event>()
            .Where(x => x.PersonId == id
                && x.TreatmentId != null
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric?> GetMetric(long id) => db.GetTable<Metric>().FirstOrDefaultAsync(x => x.Id == id);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end)
    {
        return db.GetTable<Data.Models.Metric>()
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
        IQueryable<MetricType> query = db.GetTable<MetricType>();

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<MetricType?> GetMetricType(int type) => db.GetTable<MetricType>().FirstOrDefaultAsync(x => x.Id == type);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<Person>> GetPatients(long user, DateTime now, Api.Models.RightType right)
    {
        return (from u in db.GetTable<Person>()
                join r in db.GetTable<Right>() on u.Id equals r.PersonId
                where r.Stop == null || (r.Stop >= now && r.Start <= now)
                where r.UserId == user
                where r.Type == (int)right
                select u).Distinct().ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<List<EventType>> GetEventTypes(bool? all)
    {
        IQueryable<EventType> query = db.GetTable<EventType>();

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToListAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(EventType eventType)
    {
        return db.GetTable<EventType>().InsertAsync(() => new EventType
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
        return db.GetTable<Data.Models.MetricType>().InsertAsync(() => new Data.Models.MetricType
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
    public Task Insert(Api.Models.CreateMetric metric, long person, long user)
    {
        return db.GetTable<Metric>().InsertAsync(() => new Metric
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
        return db.GetTable<EventType>()
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
        return db.GetTable<MetricType>()
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
    public Task<bool> ExistsEvent(long person, string tag) => db.GetTable<Event>().AnyAsync(x => x.PersonId == person && x.Tag == tag);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsMetric(long person, string tag, Api.Models.FileTypes source)
    => db.GetTable<Metric>().AnyAsync(x => x.PersonId == person && x.Tag == tag && x.Source == (int)source);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public async Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Api.Models.MetricSummary action, DateTime start, DateTime end)
    {
        // Use a manual command to use the SQL function NTILE
        var groups = db.FromSql<ChunkedMetric>($"SELECT NTILE({tile}) OVER (ORDER BY date) as chunk,* FROM health.metric m WHERE m.PersonId = {id} AND m.Type = {type} AND m.Date <= {end} AND m.Date >= {start}")
         .AsSubQuery()
         .GroupBy(x => x.Chunk);

        IQueryable<Chunked> query;
        switch (action)
        {
            case Api.Models.MetricSummary.Mean:
                query = groups.Select(x => new Chunked
                {
                    Chunk = x.Key,
                    Date = x.Min(y => y.Date),
                    Value = x.Average(y => Sql.Convert<double, string>(y.Value)).ToString(),
                });
                break;
            case Api.Models.MetricSummary.Sum:
                query = groups.Select(x => new Chunked
                {
                    Chunk = x.Key,
                    Date = x.Min(y => y.Date),
                    Value = x.Sum(y => Sql.Convert<double, string>(y.Value)).ToString(),
                });
                break;
            default:
                query = groups.Select(x => new Chunked
                {
                    Chunk = x.Key,
                    Date = x.Min(y => y.Date),
                    Value = x.Min(y => y.Value),
                });
                break;

        }

        var chunks = await query.OrderBy(x => x.Chunk)
       .ToListAsync();

        return chunks.Select(x => new Metric
        {
            Date = x.Date,
            Value = x.Value ?? string.Empty,
            Tag = x.Chunk.ToString(),
        }).ToArray();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric?> GetLastMetrics(long id, int type, DateTime start, DateTime end)
    {
        return db.GetTable<Metric>().Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
                .OrderByDescending(x => x.Date)
                .Take(1)
                .SingleOrDefaultAsync();
    }
}
