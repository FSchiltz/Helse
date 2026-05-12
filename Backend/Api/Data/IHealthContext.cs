using Api.Data.Models;

namespace Api.Data;

/// <summary>
/// Interface for the health context?
/// </summary>
public interface IHealthContext : IContext
{
    /// <summary>
    /// Insert a new event into the database
    /// </summary> 
    /// <param name="e">The event</param>
    /// <param name="person">The person to which add the event to</param>
    /// <param name="user">The user making the addition</param>
    Task Insert(Api.Models.Events.CreateEvent e, long person, long user);

    /// <summary>
    /// Get a single event by id
    /// </summary>
    /// <param name="id">The event id</param>
    /// <returns>The event if found, null otherwise</returns>
    Task<Event?> GetEvent(long id);

    /// <summary>
    /// Get events for a person in a given time frame
    /// </summary>
    /// <param name="id">The person id</param>
    /// <param name="start">The start of the time frame</param>
    /// <param name="end">The end of the time frame</param>
    /// <returns>The events matching the criteria</returns>
    Task<Event[]> GetEvents(long id, int type, DateTime start, DateTime end);

    /// <summary>
    /// Get the events to notify
    /// </summary>
    /// <param name="start">The start of the time frame</param>
    /// <param name="end">The end of the time frame</param>
    Task<Event[]> GetEventToPublish(DateTime start, DateTime end);

    /// <summary>
    /// Mark an event as having had its notification sent
    /// </summary>
    /// <param name="id">The event id</param>
    Task MarkEventNotificationSent(long id);

    /// <summary>
    /// Delete an event by id
    /// </summary>
    /// <param name="id">The event id</param>
    Task DeleteEvent(long id);

    /// <summary>
    /// Update an event
    /// </summary>
    /// <param name="e">The event to update</param>
    Task Update(Api.Models.Events.UpdateEvent e);

    Task<EventType[]> GetEventTypes(bool? all);
    Task Insert(EventType metric);
    Task Update(EventType type);
    Task<int> DeleteEventType(long id);

    Task<MetricType[]> GetMetricTypes(bool? all);
    Task<int> DeleteMetricType(long id);
    Task Update(MetricType metric);
    Task Insert(MetricType metric);

    Task DeleteMetric(long id);
    Task<Metric?> GetMetric(long id);
    Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end);
    Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Api.Models.Metrics.MetricSummary action, DateTime start, DateTime end);
    Task Insert(Api.Models.Metrics.CreateMetric metric, long person, long id);
    Task Update(Api.Models.Metrics.UpdateMetric metric);

    Task<Person[]> GetPatients(long id, DateTime now, Api.Models.Settings.RightType view);
    Task<Event[]> GetEvents(long id, Api.Models.Settings.RightType view, DateTime start, DateTime end);
    Task<Event[]> GetEvents(long id, DateTime start, DateTime end);

    Task<Person[]> GetAllPatients();

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
