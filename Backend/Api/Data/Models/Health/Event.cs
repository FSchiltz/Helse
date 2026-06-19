using Helse.Api.Data.Models.File;
using Helse.Api.Data.Models.Persons;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Health;

[Table(Schema = "health")]
public class Event
{
    [PrimaryKey, Identity]
    public long Id { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Persons.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Persons.User.Id))]
    public User? User { get; set; }

    [Column]
    public long? FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Files.Id))]
    public Files? File { get; set; }

    [Column]
    public long? TreatmentId { get; set; }

    [Association(ThisKey = nameof(TreatmentId), OtherKey = nameof(Health.Treatment.Id))]
    public Treatment? Treatment { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column]
    public string? Description { get; set; }

    [Column, NotNull]
    public required DateTime Start { get; set; }

    [Column, NotNull]
    public required DateTime Stop { get; set; }

    [Column, NotNull]
    public bool Valid { get; set; }

    [Column, NotNull]
    public bool NotificationSent { get; set; }

    [Column]
    public long? AddressId { get; set; }

    [Association(ThisKey = nameof(AddressId), OtherKey = nameof(Persons.Address.Id))]
    public Address? Address { get; set; }

    [Column]
    public string? Tag { get; set; }

    [Column]
    public DateTime Created { get; set; }

    [Column]
    public DateTime? NotificationTime { get; set; }

    [Column]
    public int Source { get; set; }

    [Column]
    public required string SourceId { get; set; }
}
