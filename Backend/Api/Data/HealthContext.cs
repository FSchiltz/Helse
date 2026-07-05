using System.Data;
using Helse.Models.Persons;
using LinqToDB;
using LinqToDB.Async;
using LinqToDB.Data;

namespace Helse.Api.Data;

internal class HealthContext(DataConnection db, SlowQueryLogInterceptor interceptor)
: BaseContext(db, interceptor), IHealthContext
{
    /// <inheritdoc/>
    public Task<Models.Persons.Person[]> GetPatients(long user, DateTime now, RightType right)
    {
        return (from u in Db.GetTable<Models.Persons.Person>()
                join r in Db.GetTable<Models.Persons.Right>() on u.Id equals r.PersonId
                where r.Stop == null || (r.Stop >= now && r.Start <= now)
                where r.UserId == user
                where r.Type == (int)right
                select u).Distinct().ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<Models.Persons.Person[]> GetAllPatients()
    {
        return Db.GetTable<Models.Persons.Person>().ToArrayAsync();
    }
}
