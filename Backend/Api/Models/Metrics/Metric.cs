namespace Api.Models.Metrics;

public class Metric : MetricBase
{
    public long Id { get; set; }
    
    public long Person { get; set; }

    public long User { get; set; }
}
