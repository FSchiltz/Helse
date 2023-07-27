using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "person")]
public class User
{
    public static User Empty => new (){
        Identifier = string.Empty,
        Password = string.Empty,
    };

    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Models.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public required string Identifier { get; set; }

    [Column, NotNull]
    public required string Password { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column]
    public string? Email { get; set; }

    [Column]
    public string? Phone { get; set; }
}