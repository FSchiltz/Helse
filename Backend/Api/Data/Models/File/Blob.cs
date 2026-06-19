using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.File;

[Table(Schema = "file")]
internal class Blob
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Files.Id))]
    public Files? File { get; set; }

    [Column, NotNull]
    public required string Data { get; set; }

    [Column, NotNull]
    public int Type { get; set; }
}
