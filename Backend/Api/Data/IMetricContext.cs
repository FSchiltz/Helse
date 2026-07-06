using Helse.Api.Data.Models.Health;
using Helse.Models.Common;

namespace Helse.Api.Data;

internal interface IMetricContext : IContext
{
    Task<MetricType[]> GetMetricTypes(bool? all, long? group);

    Task<int> DeleteMetricType(long id);

    Task Update(Helse.Models.Metrics.UpdateMetricType metric);

    Task Insert(Helse.Models.Metrics.CreateMetricType metric);

    Task DeleteMetric(long id, long personId);

    Task<Metric?> GetMetric(long id);

    Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end);

    Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Helse.Models.Metrics.MetricSummary action, DateTime start, DateTime end);

    Task<long> Insert(Helse.Models.Metrics.CreateMetric metric, long person, long id);

    Task Update(Helse.Models.Metrics.UpdateMetric metric);

    Task<bool> ExistsMetric(long person, long type, int source, string sourceId);

    /// <summary>
    /// Get a single metric type
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    Task<MetricType?> GetMetricType(long type);

    /// <summary>
    /// Get the last metric in the given time frame if any
    /// </summary>
    /// <param name="id"></param>
    /// <param name="type"></param>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    Task<Metric?> GetLastMetrics(long id, int type, DateTime start, DateTime end);

    Task<int> DeleteMetricGroup(long id);

    Task Update(Helse.Models.Metrics.UpdateGroup metricGroup);

    Task Insert(Helse.Models.Metrics.CreateGroup metricGroup);

    Task<MetricGroup[]> GetMetricGroups();

    Task<Metric[]> SearchMetricsAsync(long person, Helse.Models.Metrics.SearchMetric search, Pagination pagination);

    Task<long> CountMetricsAsync(long person, Helse.Models.Metrics.SearchMetric search);

    Task DeleteMetrics(long[] ids, long person);

    Task UpdateBulk(Helse.Models.Metrics.PatchMetric metric, long value);
}
