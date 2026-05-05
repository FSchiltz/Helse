namespace Api.Models.Metrics;

public abstract class MetricBase
{
    public DateTime Date { get; set; }

    public required string Value { get; set; }

    public string? Tag { get; set; }

    public long Type { get; set; }

    public FileTypes Source { get; set; }
}
