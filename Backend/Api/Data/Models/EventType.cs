using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table( Schema = "health")]
public class EventType
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public string? Description { get; set; }
}