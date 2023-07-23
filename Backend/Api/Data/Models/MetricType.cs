using LinqToDB.Mapping;

namespace Api.Data.Models;

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
}