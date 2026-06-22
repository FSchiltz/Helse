using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Health;

[Table(Schema = "health")]
internal class EventType
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public string? Description { get; set; }

    // If the event is standalone or part of a treatment
    [Column, NotNull]
    public bool StandAlone { get; set; }

    [Column]
    public bool UserEditable { get; set; }

    [Column]
    public bool Visible { get; set; }

    [Column]
    public TimeSpan? TimeDifference { get; set; }

    [Column]
    public long GroupId { get; set; }
}