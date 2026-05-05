using Api.Models.Events;

namespace Api.Models;

public class UpdateEvent : BaseEvent
{
    public long Id { get; set; }
}