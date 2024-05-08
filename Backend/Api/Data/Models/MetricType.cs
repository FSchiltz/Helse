using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class MetricType
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public string? Description { get; set; }

    [Column]
    public string? Unit { get; set; }

    [Column]
    public long Type { get; set; }

    [Column]
    public long SummaryType { get; set; }
}