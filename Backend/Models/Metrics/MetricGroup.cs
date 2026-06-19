namespace Helse.Models.Metrics;

public class MetricGroup
{
    public required string Name { get; set; }

    public required string Description { get; set; }

    public bool ShowOnDashboard { get; set; }

    public bool ShowTitle { get; set; }

    public long Id { get; set; }
}
