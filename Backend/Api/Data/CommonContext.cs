using Api.Data.Models.Common;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public class CommonContext(DataConnection db) : ICommonContext
{
    public Task<LinkedUnits?> GetUnitAsync(int unitsId)
    {
        return db.GetTable<Units>()
        .LeftJoin(db.GetTable<Units>(), (x, y) => x.BaseUnit == y.Id, (x, y) => new LinkedUnits(x, y))
        .FirstOrDefaultAsync(x => x.Unit.Id == unitsId);
    }

    public Task<LinkedUnits[]> GetUnitsAsync()
    {
        return db.GetTable<Units>()
        .LeftJoin(db.GetTable<Units>(), (x, y) => x.BaseUnit == y.Id, (x, y) => new LinkedUnits(x, y))
        .ToArrayAsync();
    }

}
