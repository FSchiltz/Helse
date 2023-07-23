using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Metric
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Data.Models.Person.Id))]
    public required Person Person { get; set; }

    [Column, NotNull]
    public long User { get; set; }

    [Column, NotNull]
    public DateTime Date { get; set; }

    [Column, NotNull]
    public required string Value { get; set; }

    [Column]
    public string? Unit { get; set; }
}
