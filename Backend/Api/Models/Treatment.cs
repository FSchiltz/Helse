namespace Api.Models;

public class CreateTreatment : Treatement
{
    public long? PersonId { get; set; }
}

public class Treatement
{
    public List<Event> Events { get; set; } = [];

    public TreatmentType Type { get; set; }
}
