namespace Helse.Models.Events;

public class UpdateEvent : CreateEvent
{
    public long Id { get; set; }
}


public class PatchEvent : BaseEvent
{
    public bool UpdateDescription { get; set; }

    public bool UpdateStop { get; set; }

    public bool UpdateStart { get; set; }

    public bool UpdateTag { get; set; }

    public long[] Ids { get; set; } = [];
}