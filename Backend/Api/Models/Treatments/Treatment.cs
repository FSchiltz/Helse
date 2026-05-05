using Api.Models.Events;

namespace Api.Models.Treatments;

public class Treatment
{
    public List<Event> Events { get; set; } = [];

    public TreatmentType Type { get; set; }
}
