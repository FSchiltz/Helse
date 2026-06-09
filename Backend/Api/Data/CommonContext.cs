using Api.Data.Models.Common;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public class CommonContext(DataConnection db) : ICommonContext
{
    public Task<Units?> GetUnitAsync(int unitsId)
    {
        IQueryable<Units> query = db.GetTable<Units>()
        .LoadWith(x => x.BaseUnitObject);

        return query.FirstOrDefaultAsync(x => x.Id == unitsId);
    }

    public Task<Units[]> GetUnitsAsync()
    {
        IQueryable<Units> query = db.GetTable<Units>().LoadWith(x => x.BaseUnitObject);

        return query.ToArrayAsync();
    }
}
