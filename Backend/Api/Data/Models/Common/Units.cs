using LinqToDB.Mapping;

namespace Api.Data.Models.Common;

[Table(Schema = "common")]
public class Units
{
    [Column]
    public required int Id { get; set; }

    [Column]
    public required string Code { get; set; }

    [Column]
    public string? Description { get; set; }

    [Column]
    public required int Type { get; set; }

    [Column]
    public int? BaseUnit { get; set; }

    [Association(ThisKey = nameof(BaseUnit), OtherKey = nameof(Common.Units.Id))]
    public Units? BaseUnitObject { get; set; }

    [Column]
    public double? ConversionFactor { get; set; }

    [Column]
    public string? Formula { get; set; }
}