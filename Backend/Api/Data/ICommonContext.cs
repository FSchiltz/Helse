using Helse.Api.Data.Models.Common;

namespace Helse.Api.Data;

internal interface ICommonContext
{
    Task<Units?> GetUnitAsync(int unit);

    Task<Units[]> GetUnitsAsync();
}
