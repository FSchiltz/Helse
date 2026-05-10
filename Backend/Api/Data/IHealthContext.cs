using Api.Data.Models;

namespace Api.Data;

public interface IHealthContext : IContext
{
    Task Insert(Api.Models.Events.CreateEvent e, long person, long user);
    Task<Event?> GetEvent(long id);
    Task<List<Models.Event>> GetEvents(long id, int type, DateTime start, DateTime end);
    Task DeleteEvent(long id);
    Task Update(Api.Models.Events.UpdateEvent e);

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
    Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Api.Models.Metrics.MetricSummary action, DateTime start, DateTime end);
    Task Insert(Api.Models.Metrics.CreateMetric metric, long person, long id);
    Task Update(Api.Models.Metrics.UpdateMetric metric);

    Task<List<Person>> GetPatients(long id, DateTime now, Api.Models.Settings.RightType view);
    Task<List<Event>> GetEvents(long id, Api.Models.Settings.RightType view, DateTime start, DateTime end);
    Task<List<Event>> GetEvents(long id, DateTime start, DateTime end);

    Task<List<Event>> GetAllEvents(DateTime start, DateTime end);
    Task<List<Person>> GetAllPatients();

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
    
    Task GetEventStats(DateTime start, DateTime end);
}
