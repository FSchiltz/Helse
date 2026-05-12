using Api.Models.Admin;

namespace Api.Data;

/// <summary>
/// Context for statistics related database access
/// </summary>
public interface IStatsContext : IContext
{
    /// <summary>
    /// Get the event stats for a given time frame
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<CountByDate[]> GetEventStats(DateTime start, DateTime end);

    /// <summary>
    /// Get the count of events by type for a given time frame
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<Dictionary<int, int>> CountEventsByType(DateTime start, DateTime end);

    /// <summary>
    /// Get the metric stats for a given time frame
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<CountByDate[]> GetMetricStats(DateTime start, DateTime end);

    /// <summary>
    /// Get the count of metrics by type for a given time frame
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<Dictionary<int, int>> CountMetricsByType(DateTime start, DateTime end);

    /// <summary>
    /// Get a summary of the users in the system, with their rights and treatments
    /// </summary>
    /// <returns></returns>
    Task<CountRecord[]> GetUserSumary();
}
