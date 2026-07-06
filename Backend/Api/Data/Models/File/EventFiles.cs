using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.File;

[Table(Schema = "health")]
internal class EventFiles
{
    [Column]
    public long FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Files.Id))]
    public Files File { get; set; } = null!;

    [Column]
    public long EventId { get; set; }

    [Column]
    public DateTime Created { get; set; }
}
