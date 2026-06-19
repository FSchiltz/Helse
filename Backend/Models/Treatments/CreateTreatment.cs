using Helse.Models.Events;

namespace Helse.Models.Treatments;

public class CreateTreatment
{
    public List<CreateEvent> Events { get; set; } = [];

    public long? PersonId { get; set; }
}
