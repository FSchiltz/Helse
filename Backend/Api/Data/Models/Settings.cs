using LinqToDB;
using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "admin")]
public class Settings
{
    [PrimaryKey]
    public required string Name { get; set; } 
    
    [Column, NotNull, DataType(DataType.Json)]
    public required string Blob { get; set; }
}
