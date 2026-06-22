namespace Helse.Models.Events;

public class CreateEventType : BaseEventType
{
}

public class UpdateEventType : CreateEventType
{
    public required long Id { get; set; }
}

public class EventType : BaseEventType
{
    public required long Id { get; set; }

    public required bool UserEditable { get; set; }
}

public abstract class BaseEventType
{
    public required string Name { get; set; }

    public string? Description { get; set; }

    public bool StandAlone { get; set; }

    public bool Visible { get; set; }

    public TimeSpan? TimeDifference { get; set; }

    public required long GroupId { get; set; }
}