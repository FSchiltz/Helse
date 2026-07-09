namespace Helse.Models.Metrics;

public class MetricSummaries
{
    public required Metric[] Metrics { get; set; }

    public long Count { get; set; }
}
