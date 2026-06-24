namespace Helse.Models.Metrics;

public class SearchMetric 
{
    public required long Type { get; set; }

    /// <summary>
    /// Search by text inside the values, the metric needs to be a type that is text
    /// </summary>
    public string? Value { get; set; }

    public DateTime? From { get; set; }

    public DateTime? To { get; set; }

    public int? MinValue { get; set; }

    public int? MaxValue { get; set; }

    public bool? IsTrue { get; set; }
}
