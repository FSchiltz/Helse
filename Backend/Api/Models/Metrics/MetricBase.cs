namespace Api.Models.Metrics;

public abstract class MetricBase
{
    public required DateTime Date { get; set; }

    public required string Value { get; set; }

    public string? Tag { get; set; }

    public required long Type { get; set; }

    public FileTypes Source { get; set; }

    public required string SourceId { get; set; }
}
