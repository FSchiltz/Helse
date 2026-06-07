using Api.Models.Common;
using Api.Models.Imports;

namespace Api.Models.Metrics;

public class UpdateMetric : CreateMetric
{
    public long Id { get; set; }
}

public class Metric : MetricBase
{
    public required long Id { get; set; }

    public required long Person { get; set; }

    public long User { get; set; }

    public Unit? Unit { get; set; }
}

public class CreateMetric : MetricBase
{
    public int? Unit { get; set; }
}

public abstract class MetricBase
{
    public required DateTime Date { get; set; }

    public required string Value { get; set; }

    public string? Tag { get; set; }

    public required long Type { get; set; }

    public FileTypes Source { get; set; }

    public required string SourceId { get; set; }
}
