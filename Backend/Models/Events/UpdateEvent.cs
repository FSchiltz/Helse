namespace Helse.Models.Events;

public class UpdateEvent : BaseEvent
{
    public long Id { get; set; }
}


public class PatchEvent : UpdateEvent
{
    public bool UpdateDescription { get; set; }

    public bool UpdateStop { get; set; }

    public bool UpdateStart { get; set; }

    public bool UpdateTag { get; set; }

    public long[] Ids { get; set; } = [];
}