using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "person")]
public class Right
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public long? PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Data.Models.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Data.Models.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column]
    public DateTime? Stop { get; set; }

    [Column, NotNull]
    public int Type { get; set; }
}
