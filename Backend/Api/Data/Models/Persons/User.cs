using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
internal class User
{
    public static User Empty => new()
    {
        Identifier = string.Empty,
        Password = string.Empty,
        Created = DateTime.Now,
    };

    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Persons.Person.Id))]
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

    public bool HasRight(UserType type)
    {
        return ((UserType)Type).HasFlag(type);
    }

    [Column, NotNull]
    public required DateTime Created { get; set; }
}
