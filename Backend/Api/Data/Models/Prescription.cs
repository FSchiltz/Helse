using LinqToDB.Mapping;

namespace Api.Data.Models;

public class Prescription
{
    [PrimaryKey]
    public long Id { get; set; }
    public long User { get; set; }
    public long File { get; set; }
    public long Person { get; set; }
    public DateTime Start { get; set; }
    public DateTime End { get; set; }
}
