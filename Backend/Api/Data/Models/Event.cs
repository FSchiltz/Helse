using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Event
{
    [PrimaryKey]
    public long Id { get; set; }
    public long Person { get; set; }
    public long User { get; set; }
    public long File { get; set; }
    public long Treatment { get; set; }
    public int Type { get; set; }
    public string? Description { get; set; }
    public DateTime Start { get; set; }
    public DateTime End { get; set; }
    public bool Valid { get; set; }
    public long Address { get; set; }
}
