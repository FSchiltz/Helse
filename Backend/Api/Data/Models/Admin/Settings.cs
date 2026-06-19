using LinqToDB;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Admin;

[Table(Schema = "admin")]
internal class Settings
{
    [PrimaryKey]
    public required string Name { get; set; }

    [Column, NotNull, DataType(DataType.Json)]
    public required string Blob { get; set; }
}
