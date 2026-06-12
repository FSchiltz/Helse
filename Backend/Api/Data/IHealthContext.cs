using Api.Data.Models.Health;
using Api.Models.Persons;

namespace Api.Data;

/// <summary>
/// Interface for the health context.
/// </summary>
public interface IHealthContext : IContext
{
    Task<Models.Persons.Person[]> GetPatients(long id, DateTime now, RightType view);

    Task<Event[]> GetTreatmentEvents(long id, DateTime start, DateTime end);

    Task<Models.Persons.Person[]> GetAllPatients();
}
