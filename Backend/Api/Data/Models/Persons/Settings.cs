using LinqToDB;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
public class Settings
{
    [Column, NotNull]
    public required long Id { get; set; }

    [Column, NotNull]
    public required string Name { get; set; }

    [Column, NotNull, DataType(DataType.Json)]
    public required string Blob { get; set; }
}