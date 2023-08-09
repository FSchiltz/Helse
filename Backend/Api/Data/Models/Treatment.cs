using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Treatment
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column]
    public long? PrescriptionId { get; set; }

    [Association(ThisKey = nameof(PrescriptionId), OtherKey = nameof(Data.Models.Prescription.Id))]
    public Prescription? Prescription { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Data.Models.Person.Id))]
    public Person? Person { get; set; }
}
