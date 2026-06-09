using LinqToDB.Mapping;

namespace Api.Data.Models.Persons;

[Table(Schema = "person")]
public class Right
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public long? PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Persons.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Persons.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column]
    public DateTime? Stop { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column, NotNull]
    public required DateTime Created { get; set; }
}
