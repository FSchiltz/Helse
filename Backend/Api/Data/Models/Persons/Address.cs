using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
internal class Address
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column, NotNull]
    public long Person { get; set; }

    [Column]
    public string? Street { get; set; }

    [Column]
    public string? Number { get; set; }

    [Column]
    public string? Postal { get; set; }

    [Column]
    public string? Country { get; set; }
}
