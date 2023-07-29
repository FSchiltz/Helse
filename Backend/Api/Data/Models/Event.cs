using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Event
{
    [PrimaryKey]
    public long Id { get; set; } 
    
    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Data.Models.Person.Id))]
    public Person? Person { get; set; }

    [Column, NotNull]
    public long UserId { get; set; }

    [Association(ThisKey = nameof(UserId), OtherKey = nameof(Data.Models.User.Id))]
    public User? User { get; set; }

    [Column]
    public long? FileId { get; set; }

    [Association(ThisKey = nameof(FileId), OtherKey = nameof(Data.Models.Files.Id))]
    public Files? File { get; set; }

    [Column]
    public long? TreatmentId { get; set; }

    [Association(ThisKey = nameof(TreatmentId), OtherKey = nameof(Data.Models.Treatment.Id))]
    public Treatment? Treatment { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column]
    public string? Description { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column, NotNull]
    public DateTime Stop { get; set; }

    [Column, NotNull]
    public bool Valid { get; set; }

    [Column]
    public long? AddressId { get; set; }

    [Association(ThisKey = nameof(AddressId), OtherKey = nameof(Data.Models.Address.Id))]
    public Treatment? Address { get; set; }

    
}
