using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.File;

[Table(Schema = "file")]
public class Files
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public DateTime Creation { get; set; }

    [Column]
    public DateTime Created { get; set; }
}
