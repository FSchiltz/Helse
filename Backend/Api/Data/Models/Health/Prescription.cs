using Helse.Api.Data.Models.File;
using Helse.Api.Data.Models.Persons;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Health;

[Table(Schema = "health")]
public class Prescription
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Persons.User.Id))]
    public User? User { get; set; }

    [Column, NotNull]
    public long FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Files.Id))]
    public Files? File { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column, NotNull]
    public DateTime End { get; set; }

    [Column]
    public DateTime Created { get; set; }
}
