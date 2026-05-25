namespace Api.Models.Metrics;

public class Metric : MetricBase
{
    public required long Id { get; set; }

    public required long Person { get; set; }

    public long User { get; set; }
}
