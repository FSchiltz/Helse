using Helse.Models.Events;

namespace Helse.Models.Treatments;

public class Treatment
{
    public List<Event> Events { get; set; } = [];

    public TreatmentType Type { get; set; }
}
