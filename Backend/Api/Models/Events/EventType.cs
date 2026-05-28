namespace Api.Models.Events;

public class EventType
{
    public required string Name { get; set; }

    public string? Description { get; set; }

    public bool StandAlone { get; set; }

    public bool Visible { get; set; }

    public long Id { get; set; }
}