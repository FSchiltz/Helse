using LinqToDB.Mapping;

namespace Api.Data.Models;

[Table(Schema = "health")]
public class Treatment
{
    [PrimaryKey]
    public long Id { get; set; }

    [Column, NotNull]
    public long PrescriptionId { get; set; }

    [Association(ThisKey = nameof(PrescriptionId), OtherKey = nameof(Data.Models.Prescription.Id))]
    public Prescription? Prescription { get; set; }

    [Column, NotNull]
    public int Type { get; set; }
}
