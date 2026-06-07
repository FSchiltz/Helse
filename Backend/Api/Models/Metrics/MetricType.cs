using Api.Models.Common;

namespace Api.Models.Metrics;

public class UpdateMetricType : CreateMetricType
{
    public required long Id { get; set; }
}

public class CreateMetricType : MetricTypeBase
{
    public required int Unit { get; set; }
}

public class MetricType : MetricTypeBase
{
    public required long Id { get; set; }

    public required Unit Unit { get; set; }
}

public class MetricTypeBase
{
    public required string Name { get; set; }

    public MetricSummary SummaryType { get; set; }

    public string? Description { get; set; }

    public MetricDataType Type { get; set; }

    public required bool UserEditable { get; set; }

    public bool Visible { get; set; }

    public bool ShowOnDashboard { get; set; }

    public required long GroupId { get; set; }
}
