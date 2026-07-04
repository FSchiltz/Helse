using Helse.Api.Data.Models.Health;
using Helse.Models.Persons;

namespace Helse.Api.Data;

/// <summary>
/// Interface for the health context.
/// </summary>
internal interface IHealthContext : IContext
{
    Task<Models.Persons.Person[]> GetPatients(long id, DateTime now, RightType view);

    Task<Models.Persons.Person[]> GetAllPatients();
}
