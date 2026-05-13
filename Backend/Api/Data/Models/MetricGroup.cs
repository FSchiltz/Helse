using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class MetricGroup
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public required string Description { get; set; }

    [Column]
    public bool ShowTitle { get; set; }

    [Column]
    public bool ShowOnDashboard { get; set; }
}
