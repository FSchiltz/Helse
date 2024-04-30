using Api.Data.Models;
using LinqToDB;
using LinqToDB.Data;

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
    Task DeleteEventType(long id);
    Task<List<MetricType>> GetMetricTypes();
    Task DeleteMetricType(long id);
    Task Update(MetricType metric);
    Task Insert(MetricType metric);
    Task DeleteMetric(long id);
    Task<Metric?> GetMetric(long id);
    Task<List<Metric>> GetMetrics(long id, long type, DateTime start, DateTime end);
    Task Insert(Api.Models.CreateMetric metric, long v, long id);
    Task<List<Person>> GetPatients(long id, DateTime now, Api.Models.RightType view);
    Task<List<Event>> GetEvents(long id, Api.Models.RightType view, DateTime start, DateTime end);
    Task<List<Event>> GetEvents(long id, DateTime start, DateTime end);
    Task<bool> ExistsEvent(long person, string tag);
    Task<bool> ExistsMetric(long person, string tag);
}

public class HealthContext(DataConnection db) : IHealthContext
{
    public Task<DataConnectionTransaction> BeginTransactionAsync() => db.BeginTransactionAsync();

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

    public Task DeleteEvent(long id) => db.GetTable<Event>().DeleteAsync(x => x.Id == id);

    public Task DeleteEventType(long id) => db.GetTable<EventType>().DeleteAsync(x => x.Id == id);

    public Task DeleteMetric(long id) => db.GetTable<Data.Models.Metric>().DeleteAsync(x => x.Id == id);

    public Task DeleteMetricType(long id) => db.GetTable<MetricType>().DeleteAsync(x => x.Id == id);

    public Task<Event?> GetEvent(long id) => db.GetTable<Event>().FirstOrDefaultAsync(x => x.Id == id);

    public Task<List<Event>> GetEvents(long id, int type, DateTime start, DateTime end)
    {
        return db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    public Task<List<Event>> GetEvents(long user, Api.Models.RightType view, DateTime start, DateTime end)
    {
        return (from e in db.GetTable<Data.Models.Event>()
                join r in db.GetTable<Data.Models.Right>() on e.PersonId equals r.PersonId
                where e.Start <= end && start <= e.Stop
                where r.UserId == user && r.Type == (int)view
                select e)
            .ToListAsync();
    }

    public Task<List<Event>> GetEvents(long id, DateTime start, DateTime end)
    {
        return db.GetTable<Data.Models.Event>()
            .Where(x => x.PersonId == id
                && x.TreatmentId != null
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();
    }

    public Task<Metric?> GetMetric(long id) => db.GetTable<Metric>().FirstOrDefaultAsync(x => x.Id == id);

    public Task<List<Metric>> GetMetrics(long id, long type, DateTime start, DateTime end)
    {
        return db.GetTable<Data.Models.Metric>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
            .ToListAsync();
    }

    public Task<List<MetricType>> GetMetricTypes() => db.GetTable<MetricType>().ToListAsync();

    public Task<List<Person>> GetPatients(long user, DateTime now, Api.Models.RightType right)
    {
        return (from u in db.GetTable<Person>()
                join r in db.GetTable<Right>() on u.Id equals r.PersonId
                where r.Stop == null || (r.Stop >= now && r.Start <= now)
                where r.UserId == user
                where r.Type == (int)right
                select u).Distinct().ToListAsync();
    }

    public Task<List<EventType>> GetEventTypes(bool? all)
    {
        IQueryable<EventType> query = db.GetTable<EventType>();

        if (all != null)
            query = query.Where(x => x.StandAlone == all);

        return query.ToListAsync();
    }

    public Task Insert(EventType metric)
    {
        return db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = metric.Name,
            Description = metric.Description,
            StandAlone = metric.StandAlone,
        });
    }

    public Task Insert(MetricType metric)
    {
        return db.GetTable<Data.Models.MetricType>().InsertAsync(() => new Data.Models.MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            Unit = metric.Unit,
        });
    }

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
        });
    }

    public Task Update(EventType type)
    {
        return db.GetTable<EventType>()
            .Where(x => x.Id == type.Id)
            .Set(x => x.Name, type.Name)
            .Set(x => x.Description, type.Description)
            .UpdateAsync();
    }

    public Task Update(MetricType metric)
    {
        return db.GetTable<MetricType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .Set(x => x.Unit, metric.Unit)
            .UpdateAsync();
    }

    public Task<bool> ExistsEvent(long person, string tag) => db.GetTable<Event>().AnyAsync(x => x.PersonId == person && x.Tag == tag);

    public Task<bool> ExistsMetric(long person, string tag) => db.GetTable<Metric>().AnyAsync(x => x.PersonId == person && x.Tag == tag);
}
