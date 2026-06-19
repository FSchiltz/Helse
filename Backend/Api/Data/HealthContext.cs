using System.Data;
using Api.Data.Models.Health;
using Api.Models.Persons;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Mapping;

namespace Api.Data;

public class HealthContext(DataConnection db, SlowQueryLogInterceptor interceptor) : BaseContext(db, interceptor), IHealthContext, IMetricContext, IEventContext
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

    /// <inheritdoc/>
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
            NotificationTime = e.NotificationTime,
            Source = (int)e.Source,
            SourceId = e.SourceId,
        });
    }

    /// <inheritdoc/>
    public Task DeleteEvent(long id) => Db.GetTable<Event>().DeleteAsync(x => x.Id == id);

    /// <inheritdoc/>
    public Task<int> DeleteEventType(long id) => Db.GetTable<EventType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <inheritdoc/>
    public Task DeleteMetric(long id) => Db.GetTable<Metric>().DeleteAsync(x => x.Id == id);

    /// <inheritdoc/>
    public Task<int> DeleteMetricType(long id) => Db.GetTable<MetricType>().DeleteAsync(x => x.Id == id && x.UserEditable);

    /// <inheritdoc/>
    public Task<Event?> GetEvent(long id) => Db.GetTable<Event>().FirstOrDefaultAsync(x => x.Id == id);

    /// <inheritdoc/>
    public Task<Event[]> GetEvents(long id, int type, DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<Event[]> GetEvents(long user, RightType right, DateTime start, DateTime end)
    {
        return (from e in Db.GetTable<Event>()
                join r in Db.GetTable<Models.Persons.Right>() on e.PersonId equals r.PersonId
                where e.Start <= end && start <= e.Stop
                where r.UserId == user && r.Type == (int)right
                select e)
            .ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<Event[]> GetTreatmentEvents(long id, DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.TreatmentId != null
                && x.Start <= end && start <= x.Stop)
            .ToArrayAsync();
    }

    public Task<Event[]> GetEventToPublish(DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.NotificationTime != null && x.NotificationTime > start && x.NotificationTime <= end && !x.NotificationSent)
            .ToArrayAsync();
    }

    public Task MarkEventNotificationSent(long id)
    {
        return Db.GetTable<Event>().Where(
                x => x.Id == id)
            .Set(x => x.NotificationSent, true)
            .UpdateAsync();
    }

    /// <inheritdoc/>
    public Task<Metric?> GetMetric(long id)
    {
        IQueryable<Metric> query = Db.GetTable<Metric>().LoadWith(x => x.UnitObject);
        return query.FirstOrDefaultAsync(x => x.Id == id);
    }

    /// <inheritdoc/>
    public Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end)
    {
        IQueryable<Metric> query = Db.GetTable<Metric>().LoadWith(x => x.UnitObject);
        return query.Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
            .OrderBy(x => x.Date)
            .ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<MetricType[]> GetMetricTypes(bool? all, long? group)
    {
        IQueryable<MetricType> query = Db.GetTable<MetricType>().LoadWith(x => x.UnitObject);

        if (all == false)
        {
            query = query.Where(x => x.Visible);
        }

        if (group is not null)
        {
            query = query.Where(x => x.GroupId == group);
        }

        return query.OrderBy(x => x.Id).ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<MetricType?> GetMetricType(long type)
    {
        IQueryable<MetricType> query = Db.GetTable<MetricType>().LoadWith(x => x.UnitObject);

        return query.FirstOrDefaultAsync(x => x.Id == type);
    }

    /// <inheritdoc/>
    public Task<Models.Persons.Person[]> GetPatients(long user, DateTime now, RightType right)
    {
        return (from u in Db.GetTable<Models.Persons.Person>()
                join r in Db.GetTable<Models.Persons.Right>() on u.Id equals r.PersonId
                where r.Stop == null || (r.Stop >= now && r.Start <= now)
                where r.UserId == user
                where r.Type == (int)right
                select u).Distinct().ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<Models.Persons.Person[]> GetAllPatients()
    {
        return Db.GetTable<Models.Persons.Person>().ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<EventType[]> GetEventTypes(bool? all, bool standalone = false)
    {
        IQueryable<EventType> query = Db.GetTable<EventType>().Where(x => x.StandAlone);

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task Insert(Api.Models.Events.EventType eventType)
    {
        return Db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = eventType.Name,
            Description = eventType.Description,
            StandAlone = eventType.StandAlone,
            UserEditable = true,
            Visible = eventType.Visible,
            TimeDifference = eventType.TimeDifference,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(Api.Models.Metrics.CreateMetricType metric)
    {
        return Db.GetTable<MetricType>().InsertAsync(() => new MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            Unit = metric.Unit,
            SummaryType = (long)metric.SummaryType,
            Type = (long)metric.Type,
            UserEditable = true,
            Visible = metric.Visible,
            GroupId = metric.GroupId,
            ShowOnDashboard = metric.ShowOnDashboard,
            ValueCount = metric.ValueCount,
            TimeDifference = metric.TimeDifference,
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
            SourceId = metric.SourceId,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(Api.Models.Events.EventType type)
    {
        return Db.GetTable<EventType>()
            .Where(x => x.Id == type.Id)
            .Set(x => x.Name, type.Name)
            .Set(x => x.Description, type.Description)
            .Set(x => x.Visible, type.Visible)
            .Set(x => x.TimeDifference, type.TimeDifference)
            .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(Api.Models.Metrics.UpdateMetricType metric)
    {
        return Db.GetTable<MetricType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .Set(x => x.Unit, metric.Unit)
            .Set(x => x.Type, (long)metric.Type)
            .Set(x => x.SummaryType, (long)metric.SummaryType)
            .Set(x => x.Visible, metric.Visible)
            .Set(x => x.ShowOnDashboard, metric.ShowOnDashboard)
            .Set(x => x.GroupId, metric.GroupId)
            .Set(x => x.ValueCount, metric.ValueCount)
            .Set(x => x.TimeDifference, metric.TimeDifference)
            .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsEvent(long person, int type, int source, string sourceId)
    => Db.GetTable<Event>().AnyAsync(x => x.PersonId == person && x.Source == source && x.SourceId == sourceId && x.Type == type);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsMetric(long person, long type, int source, string sourceId)
    => Db.GetTable<Metric>().AnyAsync(x => x.PersonId == person && x.Type == type && x.SourceId == sourceId && x.Source == source);

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
       .ToArrayAsync();

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
            .Set(x => x.SourceId, metric.SourceId)
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
        .Set(x => x.NotificationTime, e.NotificationTime)
        .Set(x => x.Source, (int)e.Source)
        .Set(x => x.SourceId, e.SourceId)
        .UpdateAsync();
    }

    public Task<int> DeleteMetricGroup(long id) => Db.GetTable<MetricGroup>().DeleteAsync(x => x.Id == id);

    public Task Update(Api.Models.Metrics.MetricGroup metricGroup)
    {
        return Db.GetTable<MetricGroup>()
            .Where(x => x.Id == metricGroup.Id)
            .Set(x => x.Name, metricGroup.Name)
            .Set(x => x.Description, metricGroup.Description)
            .Set(x => x.ShowOnDashboard, metricGroup.ShowOnDashboard)
            .Set(x => x.ShowTitle, metricGroup.ShowTitle)
            .UpdateAsync();
    }

    public Task Insert(Api.Models.Metrics.MetricGroup metricGroup)
    {
        return Db.GetTable<MetricGroup>().InsertAsync(() => new MetricGroup
        {
            Name = metricGroup.Name,
            Description = metricGroup.Description,
            ShowOnDashboard = metricGroup.ShowOnDashboard,
            ShowTitle = metricGroup.ShowTitle,
        });
    }

    public Task<MetricGroup[]> GetMetricGroups() => Db.GetTable<MetricGroup>().OrderBy(x => x.Id).ToArrayAsync();

    public Task<Metric[]> SearchMetricsAsync(long person, Api.Models.Metrics.SearchMetric search)
    {
        var query = Db.GetTable<Metric>().Where(x => x.Type == search.Type && x.PersonId == person);

        if (search.From is not null)
        {
            query = query.Where(x => x.Date >= search.From);
        }

        if (search.To is not null)
        {
            query = query.Where(x => x.Date <= search.To);
        }

        if (search.Value is not null)
        {
            query = query.Where(x => x.Value.StartsWith(search.Value, StringComparison.CurrentCultureIgnoreCase));
        }

        if (search.IsTrue is not null)
        {
            query = query.Where(x => bool.Parse(x.Value) == search.IsTrue);
        }

        if (search.MinValue is not null)
        {
            query = query.Where(x => int.Parse(x.Value) >= search.MinValue);
        }

        if (search.MaxValue is not null)
        {
            query = query.Where(x => int.Parse(x.Value) <= search.MaxValue);
        }

        return query.ToArrayAsync();
    }
}
