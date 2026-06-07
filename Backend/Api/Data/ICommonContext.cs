using Api.Data.Models.Common;
using Api.Models.Common;

namespace Api.Data;

public interface ICommonContext
{
    Task<LinkedUnits?> GetUnitAsync(int unit);

    Task<LinkedUnits[]> GetUnitsAsync();
}
