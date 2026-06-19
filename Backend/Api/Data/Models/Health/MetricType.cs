using Helse.Api.Data.Models.Common;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Health;

[Table(Schema = "health")]
public class MetricType
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public string? Description { get; set; }

    [Column]
    public required int Unit { get; set; }

    [Association(ThisKey = nameof(Unit), OtherKey = nameof(Common.Units.Id))]
    public Units? UnitObject { get; set; }

    [Column]
    public long Type { get; set; }

    [Column]
    public long SummaryType { get; set; }

    [Column]
    public bool UserEditable { get; set; }

    [Column]
    public bool Visible { get; set; }

    [Column]
    public long GroupId { get; set; }

    [Column]
    public bool ShowOnDashboard { get; set; }

    [Column]
    public long? ValueCount { get; set; }

    [Column]
    public TimeSpan? TimeDifference { get; set; }
}