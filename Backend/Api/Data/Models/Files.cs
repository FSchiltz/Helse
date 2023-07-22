using LinqToDB.Mapping;

namespace Api.Data.Models;

public class Files
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public DateTime Creation { get; set; }
}
