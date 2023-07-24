namespace Api.Models;

public class Metric
{
    public long Id { get; set; }

    public long PersonId { get; set; }

    public long User { get; set; }

    public DateTime Date { get; set; }

    public required string Value { get; set; }

    public string? Unit { get; set; }

    public long Type {get;set;}
}

public class CreateMetric
{
    public DateTime Date { get; set; }

    public required string Value { get; set; }

    public string? Unit { get; set; }

    public long Type {get;set;}
}

