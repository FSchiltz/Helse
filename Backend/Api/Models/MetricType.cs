namespace Api.Models;

public class MetricType
{
    public required string Name { get; set; }
    public string? Unit { get; set; }
    public MetricSummary SummaryType { get; set; }
    public string? Description { get; set; }

    public MetricDataType Type { get; set; }
    public long Id { get; set; }

    public bool UserEditable { get; set; }

    public bool Visible { get; set; }
}

public enum MetricTypes
{
    Heart = 1,
    Oxygen = 2,
    Wheight = 3,
    Height = 4,
    Temperature = 5,
    Steps = 6,
    Calories = 7,
    Distance = 8,
    Menstruation = 9,
    Pain = 10,
    Mood = 11,
}

public enum MetricDataType
{
    Text,
    Number,
}

public enum MetricSummary
{
    Latest,
    Sum,
    Mean,
}
