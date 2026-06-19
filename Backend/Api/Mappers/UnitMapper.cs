using Helse.Api.Data.Models.Common;
using Helse.Models.Common;

namespace Helse.Api.Mappers;

internal static class UnitMapper
{
    public static Unit? ToUnit(this Units? Unit)
    {
        if (Unit is null)
        {
            return null;
        }

        return new()
        {
            Code = Unit.Code,
            Id = Unit.Id,
            Description = Unit.Description,
            Type = (UnitType)Unit.Type,
            BaseUnit = Unit.BaseUnitObject is null ? null : new()
            {
                Code = Unit.BaseUnitObject.Code,
                Id = Unit.BaseUnitObject.Id,
                Description = Unit.BaseUnitObject.Description,
                Type = (UnitType)Unit.BaseUnitObject.Type,
            },
        };
    }
}
