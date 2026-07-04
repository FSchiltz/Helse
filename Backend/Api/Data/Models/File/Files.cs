using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.File;

[Table(Schema = "file")]
internal class Files
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column]
    public DateTime Created { get; set; }

    [Column, NotNull]
    public required byte[] Data { get; set; }

    [Column, NotNull]
    public required string DataType { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Column]
    public DateTime Start { get; set; }

    [Column]
    public DateTime? Stop { get; set; }

    [Column]
    public required string Name { get; set; }

    [Column]
    public required string Description { get; set; }
}
