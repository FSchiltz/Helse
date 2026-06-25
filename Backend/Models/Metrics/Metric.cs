using Helse.Models.Common;
using Helse.Models.Imports;

namespace Helse.Models.Metrics;

public class PatchMetric : CreateMetric
{
    public bool UpdateValue { get; set; }
    
    public bool UpdateDate { get; set; }

    public bool UpdateTag { get; set; }

    public long[] Ids { get; set; } = [];
}

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
