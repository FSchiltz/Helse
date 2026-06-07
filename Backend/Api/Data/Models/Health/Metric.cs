using Api.Data.Models.Persons;
using LinqToDB.Mapping;

namespace Api.Data.Models.Health;

[Table(Schema = "health")]
public class Metric
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Persons.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Persons.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public DateTime Date { get; set; }

    [Column, NotNull]
    public required string Value { get; set; }

    [Column]
    public string? Tag { get; set; }

    [Column]
    public long Type { get; set; }

    [Association(ThisKey = nameof(Type), OtherKey = nameof(Health.MetricType.Id))]
    public MetricType? MetricType { get; set; }

    [Column]
    public int Source { get; set; }

    [Column]
    public DateTime Created { get; set; }

    [Column]
    public string SourceId { get; set; } = string.Empty;

    [Column]
    public int? Unit { get; set; }
}
