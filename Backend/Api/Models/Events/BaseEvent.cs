namespace Api.Models.Events;

public abstract class BaseEvent
{
    public int Type { get; set; }
    public string? Description { get; set; }
    public DateTime Start { get; set; }
    public DateTime Stop { get; set; }

    public string? Tag { get; set; }
}
