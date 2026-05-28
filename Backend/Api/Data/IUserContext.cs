using Api.Data.Models.Persons;
using Api.Models.Events;
using Api.Models.Persons;
using Api.Models.Settings;
using Api.Models.Treatments;

namespace Api.Data;

public interface IUserContext : IContext
{
    Task UpdatePerson(UpdatePerson update);

    Task UpdatePatient(UpdatePatient update);

    Task AddRight(long userId, long id, RightType edit);

    Task<long> Count();

    Task<PersonFromDb?> Get(string? identifier);

    Task<PersonFromDb?> Get(long id);

    Task<Right?> HasRightAsync(long id, long personId, RightType type, DateTime now);

    Task<long> InsertPerson(PersonCreation newUser);

    Task<long> InsertUser(PersonCreation newUser, long id, string password);

    Task UpdatePassword(long user, string password);

    Task<List<PersonFromDb>> GetUsers();

    Task<List<Models.Persons.Right>> GetRights(DateTime time);

    Task SetExpiryRight(long personId, DateTime now);

    Task InsertRights(IEnumerable<Models.Persons.Right> dbRights);

    Task<long> InsertTreatment(long v, TreatmentType care);

    Task InsertEvent(CreateEvent e, long person, long user, long? treatment);

    Task DeletePersonAsync(long personId);

    Task DeleteUserAsync(long userId);

    Task LinkOauth(Models.Persons.Person.OauthUser oauthUser);

    Task<PersonFromDb?> Get(string user, string issuer);
}
