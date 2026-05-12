namespace Api.Models.Events;

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
