using Api.Models.Events;

namespace Api.Models.Treatments;

public class CreateTreatment
{
    public List<CreateEvent> Events { get; set; } = [];

    public long? PersonId { get; set; }
}
