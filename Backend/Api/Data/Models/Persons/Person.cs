using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
internal class Person
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public string? Name { get; set; }

    [Column]
    public string? Surname { get; set; }

    // National identifier
    [Column]
    public string? Identifier { get; set; }

    [Column]
    public DateTime? Birth { get; set; }

    [Column]
    public byte[]? ProfilePicture { get; set; }

    [Column, NotNull]
    public required DateTime Created { get; set; }
}
