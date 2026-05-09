using Api.Data.Models;
using Api.Models.Events;
using Api.Models.Persons;
using Api.Models.Settings;
using Api.Models.Treatments;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public record PersonFromDb(User User, Models.Person Person);

public class UserContext(DataConnection db) : BaseContext(db), IUserContext
{
    /// <summary>
    /// Check that a user has the given right over someone
    /// </summary>
    /// <param name="user"></param>
    /// <param name="person"></param>
    /// <param name="type"></param>
    /// <param name="time"></param>
    /// <returns></returns>
    public async Task<Api.Models.Settings.Right?> HasRightAsync(long user, long person, RightType type, DateTime time)
     => (await Db.GetTable<Data.Models.Right>()
        .Where(x => x.UserId == user
            && x.PersonId == person
            && x.Type == (int)type
            && x.Start <= time
            && (x.Stop == null || x.Stop >= time))
        .FirstOrDefaultAsync())?.FromDb();

    public async Task UpdatePerson(UpdatePerson update)
    {
        await Db.GetTable<Data.Models.Person>()
            .Where(x => x.Id == update.Id)
            .Set(x => x.Birth, update.Birth)
            .Set(x => x.Identifier, update.Identifier)
            .Set(x => x.Name, update.Name)
            .Set(x => x.Surname, update.Surname)
            .Set(x => x.ProfilePicture, update.ProfilePicture)
            .UpdateAsync();

        var userQuery = Db.GetTable<Data.Models.User>()
            .Where(x => x.PersonId == update.Id)
            .AsUpdatable();

        if (update.Email is not null)
            userQuery = userQuery.Set(x => x.Email, update.Email);

        if (update.Phone is not null)
            userQuery = userQuery.Set(x => x.Phone, update.Phone);

        if (update.Identifier is not null)
            userQuery = userQuery.Set(x => x.Identifier, update.Identifier);

        if (update.Types is not null)
        {
            if (update.Types.Count == 0)
            {
                userQuery = userQuery.Set(x => x.Type, 0);
            }
            else
            {
                userQuery = userQuery.Set(x => x.Type, (int)update.Types.Cast<Models.UserType>().Aggregate((a, b) => a | b));
            }
        }
        await userQuery.UpdateAsync();
    }

    public Task<long> Count() => Db.GetTable<User>().LongCountAsync();

    public Task<PersonFromDb?> Get(string? identifier)
    {
        if (identifier is null)
            return Task.FromResult(default(PersonFromDb?));

        return (from u in Db.GetTable<User>()
                join p in Db.GetTable<Data.Models.Person>() on u.PersonId equals p.Id
                where u.Identifier == identifier
                select new PersonFromDb(u, p))
                                 .FirstOrDefaultAsync();
    }

    public Task UpdatePassword(long user, string password)
        => Db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();

    public Task<long> InsertPerson(PersonCreation newUser)
    {
        return Db.GetTable<Data.Models.Person>().InsertWithInt64IdentityAsync(()
            => new Data.Models.Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
                ProfilePicture = newUser.ProfilePicture,
            });
    }

    public Task InsertUser(PersonCreation newUser, long id, string password)
    {
        return Db.GetTable<User>().InsertAsync(()
                => new User
                {
                    Identifier = newUser.UserName ?? string.Empty,
                    Password = password,
                    Phone = newUser.Phone,
                    Email = newUser.Email,
                    PersonId = id,
                    Type = (int)newUser.Types.Cast<Models.UserType>().Aggregate((a, b) => a | b),
                });
    }

    public Task AddRight(long userId, long id, RightType right)
    {
        return Db.GetTable<Models.Right>().InsertAsync(() => new()
        {
            UserId = userId,
            Start = DateTime.UtcNow,
            PersonId = id,
            Type = (int)right
        });
    }

    public Task<List<PersonFromDb>> GetUsers()
    {
        var query =
        from u in Db.GetTable<User>()
        from p in Db.GetTable<Models.Person>().RightJoin(pr => pr.Id == u.PersonId)
        select new PersonFromDb(u, p);

        return query.OrderBy(x => x.User.Id).ToListAsync();
    }

    public Task<List<Models.Right>> GetRights(DateTime time)
    {
        return (from r in Db.GetTable<Models.Right>()
                where r.Stop == null || (r.Stop >= time && r.Start <= time)
                select r)
                .ToListAsync();
    }

    public Task SetExpiryRight(long personId, DateTime now)
    {
        return Db.GetTable<Models.Right>()
            .Where(x => x.UserId == personId)
            .Set(x => x.Stop, now)
            .UpdateAsync();
    }

    public Task InsertRights(IEnumerable<Models.Right> dbRights) => Db.GetTable<Models.Right>().BulkCopyAsync(dbRights);

    public Task<long> InsertTreatment(long person, TreatmentType type)
    {
        return Db.GetTable<Models.Treatment>().InsertWithInt64IdentityAsync(() => new()
        {
            PersonId = person,
            Type = (int)type,
        });
    }

    public Task InsertEvent(CreateEvent e, long person, long user, long? treatment)
    {
        return Db.GetTable<Models.Event>().InsertAsync(() => new()
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
