using Helse.Api.Data.Models.Persons;
using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Health;

[Table(Schema = "health")]
internal class Treatment
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column]
    public long? PrescriptionId { get; set; }

    [Association(ThisKey = nameof(PrescriptionId), OtherKey = nameof(Health.Prescription.Id))]
    public Prescription? Prescription { get; set; }

    [Column, NotNull]
    public int Type { get; set; }

    [Column, NotNull]
    public long PersonId { get; set; }

    [Association(ThisKey = nameof(PersonId), OtherKey = nameof(Persons.Person.Id))]
    public Person? Person { get; set; }

    [Column]
    public DateTime Created { get; set; }
}
