using Api.Data.Models;
using Api.Models;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public record PersonFromDb(User User, Models.Person Person);

public interface IUserContext : IContext
{
    Task UpdateRole(long userId, int newType);
    Task AddRight(long userId, long id, RightType edit);
    Task<long> Count();

    Task<PersonFromDb?> Get(string? identifier);

    Task<Api.Models.Right?> HasRightAsync(long id, long personId, RightType type, DateTime now);
    Task<long> InsertPerson(PersonCreation newUser);
    Task InsertUser(PersonCreation newUser, long id, string password);
    Task UpdatePassword(long user, string password);
    Task<List<PersonFromDb>> GetUsers();
    Task<List<Models.Right>> GetRights(DateTime time);
    Task SetExpiryRight(long personId, DateTime now);
    Task InsertRights(IEnumerable<Models.Right> dbRights);
    Task<long> InsertTreatment(long v, TreatmentType care);
    Task InsertEvent(CreateEvent e, long person, long user, long? treatment);
}

public class UserContext(DataConnection db) : IUserContext
{
    /// <summary>
    /// Check that a user has the given right over someone
    /// </summary>
    /// <param name="user"></param>
    /// <param name="person"></param>
    /// <param name="type"></param>
    /// <param name="time"></param>
    /// <returns></returns>
    public async Task<Api.Models.Right?> HasRightAsync(long user, long person, RightType type, DateTime time)
     => (await db.GetTable<Data.Models.Right>()
        .Where(x => x.UserId == user
            && x.PersonId == person
            && x.Type == (int)type
            && x.Start <= time
            && (x.Stop == null || x.Stop >= time))
        .FirstOrDefaultAsync())?.FromDb();

    public Task UpdateRole(long userId, int newType)
    {
        return db.GetTable<Data.Models.User>()
        .Where(x => x.Id == userId)
        .Set(x => x.Type, newType)
        .UpdateAsync();
    }

    public Task<long> Count() => db.GetTable<User>().LongCountAsync();

    public Task<PersonFromDb?> Get(string? identifier)
    {
        if (identifier is null)
            return Task.FromResult(default(PersonFromDb?));

        return (from u in db.GetTable<User>()
                join p in db.GetTable<Data.Models.Person>() on u.PersonId equals p.Id
                where u.Identifier == identifier
                select new PersonFromDb(u, p))
                                 .FirstOrDefaultAsync();
    }

    public Task UpdatePassword(long user, string password)
        => db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();

    public Task<DataConnectionTransaction> BeginTransactionAsync() => db.BeginTransactionAsync();

    public Task<long> InsertPerson(PersonCreation newUser)
    {
        return db.GetTable<Data.Models.Person>().InsertWithInt64IdentityAsync(()
            => new Data.Models.Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
            });
    }

    public Task InsertUser(PersonCreation newUser, long id, string password)
    {
        return db.GetTable<User>().InsertAsync(()
                => new User
                {
                    Identifier = newUser.UserName ?? string.Empty,
                    Password = password,
                    Phone = newUser.Phone,
                    Email = newUser.Email,
                    PersonId = id,
                    Type = (int)newUser.Type,
                });
    }

    public Task AddRight(long userId, long id, RightType right)
    {
        return db.GetTable<Data.Models.Right>().InsertAsync(() => new Data.Models.Right
        {
            UserId = userId,
            Start = DateTime.UtcNow,
            PersonId = id,
            Type = (int)right
        });
    }

    public Task<List<PersonFromDb>> GetUsers()
    {
        return (from u in db.GetTable<User>()
                from p in db.GetTable<Models.Person>().RightJoin(pr => pr.Id == u.PersonId)
                select new PersonFromDb(u, p)).OrderBy(x => x.User.Id).ToListAsync();
    }

    public Task<List<Models.Right>> GetRights(DateTime time)
    {
        return (from r in db.GetTable<Data.Models.Right>()
                where r.Stop == null || (r.Stop >= time && r.Start <= time)
                select r)
                .ToListAsync();
    }

    public Task SetExpiryRight(long personId, DateTime now)
    {
        return db.GetTable<Data.Models.Right>()
            .Where(x => x.UserId == personId)
            .Set(x => x.Stop, now)
            .UpdateAsync();
    }

    public Task InsertRights(IEnumerable<Models.Right> dbRights) => db.GetTable<Data.Models.Right>().BulkCopyAsync(dbRights);

    public Task<long> InsertTreatment(long person, TreatmentType type)
    {
        return db.GetTable<Data.Models.Treatment>().InsertWithInt64IdentityAsync(() => new Data.Models.Treatment
        {
            PersonId = person,
            Type = (int)type,
        });
    }

    public Task InsertEvent(CreateEvent e, long person, long user, long? treatment)
    {
        return db.GetTable<Data.Models.Event>().InsertAsync(() => new Data.Models.Event
        {
            PersonId = person,
            UserId = user,
            Type = e.Type,
            Description = e.Description,
            Stop = e.Stop,
            Start = e.Start,
            TreatmentId = treatment,
        });
    }
}
