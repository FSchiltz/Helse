using LinqToDB.Mapping;

namespace Api.Data.Models;

public class Treatment
{
    [PrimaryKey]
    public long Id { get; set; }
    public long Prescription { get; set; }
    public int Type { get; set; }
}
