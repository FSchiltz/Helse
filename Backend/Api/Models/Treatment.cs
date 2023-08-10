namespace Api.Models;

public class CreateTreatment
{
    public List<CreateEvent> Events { get; set; } = new();

    public long? PersonId { get; set; }
}

public class Treatement
{
    public List<Event> Events { get; set; } = new();
}