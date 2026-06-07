using Api.Data.Models.Health;
using Api.Models.Common;

namespace Api.Data.Models.Common;

public record LinkedUnits(Units Unit, Units? BaseUnit)
{
    public Unit ToUnit()
    {
        return new()
        {
            Code = Unit.Code,
            Id = Unit.Id,
            Description = Unit.Description,
            Type = (UnitType)Unit.Type,
            BaseUnit = BaseUnit is null ? null : new()
            {
                Code = BaseUnit.Code,
                Id = BaseUnit.Id,
                Description = BaseUnit.Description,
                Type = (UnitType)BaseUnit.Type,
            },
        };
    }

}

public record WithUnit<T>(T Item, LinkedUnits? Unit)
{
    public WithUnit(T item, Units? unit, Units? baseunit) :
        this(item, (unit is null) ? null : new(unit, baseunit))
    { }
}