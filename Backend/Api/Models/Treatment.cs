namespace Api.Models;

public class CreateTreatment 
{
    public List<CreateEvent> Events { get; set; } = [];

    public long? PersonId { get; set; }
}

public class Treatement
{
    public List<Event> Events { get; set; } = [];

    public TreatmentType Type { get; set; }
}
