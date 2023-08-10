namespace Api.Models;

public abstract class BaseEvent
{
    public int Type { get; set; }
    public string? Description { get; set; }
    public DateTime Start { get; set; }
    public DateTime Stop { get; set; }
}

public class Event : BaseEvent
{
    public long User { get; set; }
    public long? File { get; set; }
    public long? Treatment { get; set; }

    public long Id { get; set; }
    public long Person { get; set; }

    public bool Valid { get; set; }
    public long? Address { get; set; }
}

public class CreateEvent : BaseEvent
{
}