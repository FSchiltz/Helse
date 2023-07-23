using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "person")]
public class Person
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
}
