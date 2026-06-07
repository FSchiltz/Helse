namespace Api.Models.Common;

public class Unit
{
    public UnitType Type { get; set; }

    public required int Id { get; set; }

    public required string Code { get; set; }

    public string? Description { get; set; }

    public Unit? BaseUnit { get; set; }
}
