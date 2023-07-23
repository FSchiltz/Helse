using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "person")]
public class Address
{
    [PrimaryKey]
    public long Id { get; set; }
    public long Person { get; set; }
    public string? Street { get; set; }
    public string? Number { get; set; }
    public string? Postal { get; set; }

    public string? Country { get; set; }
}
