using Api.Models;
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
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Data.Models.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public DateTime Date { get; set; }

    [Column, NotNull]
    public required string Value { get; set; }

    [Column]
    public string? Unit { get; set; }

    [Column]
    public long Type {get;set;}

    [Association(ThisKey = nameof(Type), OtherKey = nameof(Data.Models.MetricType.Id))]
    public MetricType? MetricType { get; set; }
}
