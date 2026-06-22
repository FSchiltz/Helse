namespace Helse.Models.Events;

public class EventType
{
    public required string Name { get; set; }

    public string? Description { get; set; }

    public bool StandAlone { get; set; }

    public bool Visible { get; set; }

    public required long Id { get; set; }

    public required bool UserEditable { get; set; }

    public TimeSpan? TimeDifference { get; set; }

    public required long GroupId { get; set; }
}