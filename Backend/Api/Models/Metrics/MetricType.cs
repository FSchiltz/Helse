namespace Api.Models.Metrics;

public class MetricType
{
    public required string Name { get; set; }

    public string? Unit { get; set; }

    public MetricSummary SummaryType { get; set; }

    public string? Description { get; set; }

    public MetricDataType Type { get; set; }

    public required long Id { get; set; }

    public required bool UserEditable { get; set; }

    public bool Visible { get; set; }

    public bool ShowOnDashboard { get; set; }

    public required long GroupId { get; set; }
}
