using Api.Data.Models.Persons;
using Api.Models.Events;
using Api.Models.Persons;
using Api.Models.Treatments;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public record PersonFromDb(User User, Models.Persons.Person Person);

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
    public async Task<Api.Models.Persons.Right?> HasRightAsync(long user, long person, RightType type, DateTime time)
     => (await Db.GetTable<Models.Persons.Right>()
        .Where(x => x.UserId == user
            && x.PersonId == person
            && x.Type == (int)type
            && x.Start <= time
            && (x.Stop == null || x.Stop >= time))
        .FirstOrDefaultAsync())?.FromDb();

    public async Task UpdatePatient(UpdatePatient update)
    {
        var personQuery = Db.GetTable<Models.Persons.Person>()
            .Where(x => x.Id == update.Id)
            .AsUpdatable();

        if (update.Birth is not null)
            personQuery = personQuery.Set(x => x.Birth, update.Birth);

        if (update.Identifier is not null)
            personQuery = personQuery.Set(x => x.Identifier, update.Identifier);

        if (update.Name is not null)
            personQuery = personQuery.Set(x => x.Name, update.Name);

        if (update.Surname is not null)
            personQuery = personQuery.Set(x => x.Surname, update.Surname);

        if (update.ProfilePicture is not null)
            personQuery = personQuery.Set(x => x.ProfilePicture, update.ProfilePicture);

        await personQuery.UpdateAsync();
    }

    public async Task UpdatePerson(UpdatePerson update)
    {
        var userQuery = Db.GetTable<User>()
            .Where(x => x.Id == update.Id)
            .AsUpdatable();

        if (update.Email is not null)
            userQuery = userQuery.Set(x => x.Email, update.Email);

        if (update.Phone is not null)
            userQuery = userQuery.Set(x => x.Phone, update.Phone);

        if (update.Types is not null)
        {
            if (update.Types.Count == 0)
            {
                userQuery = userQuery.Set(x => x.Type, 0);
            }
            else
            {
                userQuery = userQuery.Set(x => x.Type, (int)update.Types.Cast<Models.Persons.UserType>().Aggregate((a, b) => a | b));
            }
        }
        await userQuery.UpdateAsync();
    }

    public Task<long> Count() => Db.GetTable<User>().LongCountAsync();

    public async Task<User?> Get(string? identifier)
    {
        if (identifier is null)
            return null;

        return await Db.GetTable<User>().FirstOrDefaultAsync(x => x.Identifier == identifier);
    }

    public async Task<User?> Get(string? identifier, string issuer)
    {
        if (identifier is null)
            return null;

        return await (from o in Db.GetTable<OauthUser>()
                      join u in Db.GetTable<User>() on o.UserId equals u.Id
                      where o.OauthSub == identifier && o.Provider == issuer
                      select u)
                                 .FirstOrDefaultAsync();
    }

    public Task UpdatePassword(long user, string password)
        => Db.GetTable<User>().Where(x => x.Id == user).Set(x => x.Password, password).UpdateAsync();

    public Task<long> InsertPerson(PersonCreation newUser)
    {
        return Db.GetTable<Models.Persons.Person>().InsertWithInt64IdentityAsync(()
            => new Models.Persons.Person
            {
                Birth = newUser.Birth,
                Identifier = newUser.Identifier,
                Name = newUser.Name,
                Surname = newUser.Surname,
                ProfilePicture = newUser.ProfilePicture,
                Created = DateTime.Now,
            });
    }

    public Task<long> InsertUser(PersonCreation newUser, long id, string password)
    {
        return Db.GetTable<User>().InsertWithInt64IdentityAsync(()
                => new User
                {
                    Identifier = newUser.UserName ?? string.Empty,
                    Password = password,
                    Phone = newUser.Phone,
                    Email = newUser.Email,
                    PersonId = id,
                    Type = (int)newUser.Types.Cast<Models.Persons.UserType>().Aggregate((a, b) => a | b),
                    Created = DateTime.Now,
                });
    }

    public Task AddRight(long userId, long id, RightType right)
    {
        return Db.GetTable<Models.Persons.Right>().InsertAsync(() => new()
        {
            UserId = userId,
            Start = DateTime.UtcNow,
            PersonId = id,
            Type = (int)right,
            Created = DateTime.Now,
        });
    }

    public Task<List<PersonFromDb>> GetUsers()
    {
        var query =
        from u in Db.GetTable<User>()
        from p in Db.GetTable<Models.Persons.Person>().RightJoin(pr => pr.Id == u.PersonId)
        select new PersonFromDb(u, p);

        return query.OrderBy(x => x.User.Id).ToListAsync();
    }

    public Task<List<Models.Persons.Right>> GetRights(DateTime time)
    {
        return (from r in Db.GetTable<Models.Persons.Right>()
                where r.Stop == null || (r.Stop >= time && r.Start <= time)
                select r)
                .ToListAsync();
    }

    public Task SetExpiryRight(long personId, DateTime now)
    {
        return Db.GetTable<Models.Persons.Right>()
            .Where(x => x.UserId == personId)
            .Set(x => x.Stop, now)
            .UpdateAsync();
    }

    public Task InsertRights(IEnumerable<Models.Persons.Right> dbRights) => Db.GetTable<Models.Persons.Right>().BulkCopyAsync(dbRights);

    public Task<long> InsertTreatment(long person, TreatmentType type)
    {
        return Db.GetTable<Models.Health.Treatment>().InsertWithInt64IdentityAsync(() => new()
        {
            PersonId = person,
            Type = (int)type,
        });
    }

    public Task InsertEvent(CreateEvent e, long person, long user, long? treatment)
    {
        return Db.GetTable<Models.Health.Event>().InsertAsync(() => new()
        {
            PersonId = person,
            UserId = user,
            Type = e.Type,
            Description = e.Description,
            Stop = e.Stop,
            Start = e.Start,
            TreatmentId = treatment,
            SourceId = e.SourceId,
        });
    }

    public async Task DeletePersonAsync(long personId)
    {
        await Db.GetTable<Models.Persons.Person>()
            .Where(x => x.Id == personId)
            .DeleteAsync();
    }

    public async Task DeleteUserAsync(long userId)
    {
        await Db.GetTable<OauthUser>()
        .Where(x => x.UserId == userId)
        .DeleteAsync();

        await Db.GetTable<User>()
        .Where(x => x.Id == userId)
        .DeleteAsync();
    }

    public Task<PersonFromDb?> Get(long id)
    {
        return (from u in Db.GetTable<User>()
                join p in Db.GetTable<Models.Persons.Person>() on u.PersonId equals p.Id
                where u.Id == id
                select new PersonFromDb(u, p))
                                 .FirstOrDefaultAsync();
    }

    public Task LinkOauth(OauthUser oauthUser)
    {
        return Db.GetTable<OauthUser>().InsertAsync(() => new()
        {
            UserId = oauthUser.UserId,
            OauthSub = oauthUser.OauthSub,
            Provider = oauthUser.Provider,
        });
    }

    public Task<Sessions?> GetSession(long id, string userSession)
    {
        return Db.GetTable<Sessions>().Where(x => x.UserId == id && x.SessionId == userSession).SingleOrDefaultAsync();
    }

    public Task<Sessions[]> GetSessions(long id)
    {
        return Db.GetTable<Sessions>().Where(x => x.UserId == id).ToArrayAsync();
    }

    public Task AddSession(Sessions session)
    {
        return Db.GetTable<Sessions>().InsertAsync(() => new()
        {
            Location = session.Location,
            SessionId = session.SessionId,
            Start = session.Start,
            Stop = session.Stop,
            UserAgent = session.UserAgent,
            UserId = session.UserId,
            Ip = session.Ip,
        });
    }

    public Task DeleteSession(long userId, string session)
    {
        return Db.GetTable<Sessions>()
        .Where(x => x.UserId == userId && x.SessionId == session)
        .DeleteAsync();
    }

    public Task DeleteSession(long userId, DateTime dateTime)
    {
        return Db.GetTable<Sessions>()
        .Where(x => x.UserId == userId && x.Stop < dateTime)
        .DeleteAsync();
    }

    public Task DeleteSession(long userId)
    {
        return Db.GetTable<Sessions>()
        .Where(x => x.UserId == userId)
        .DeleteAsync();
    }
}
