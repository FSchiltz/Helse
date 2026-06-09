using Api.Data.Models.Common;

namespace Api.Data;

public interface ICommonContext
{
    Task<Units?> GetUnitAsync(int unit);

    Task<Units[]> GetUnitsAsync();
}
