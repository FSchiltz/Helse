using Helse.Api.Data.Models.Health;

namespace Helse.Api.Data.Helpers;

internal static class MetricHelper
{
    public static IQueryable<Metric> ApplyFilter(this IQueryable<Metric> query, Helse.Models.Metrics.SearchMetric search)
    {
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
            query = query.Where(x => double.Parse(x.Value) >= search.MinValue);
        }

        if (search.MaxValue is not null)
        {
            query = query.Where(x => double.Parse(x.Value) <= search.MaxValue);
        }

        if (search.FilterSource)
        {
            query = query.Where(x => x.Source == (int)search.Source);
        }
        return query;
    }
}