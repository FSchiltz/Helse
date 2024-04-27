using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Prescription
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Data.Models.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public long FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Data.Models.Files.Id))]
    public Files? File { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column, NotNull]
    public DateTime End { get; set; }
}
