namespace Helse.Models.Persons;

public class UpdatePatient
{
    public long Id { get; set; }

    public DateTime? Birth { get; set; }

    public byte[]? ProfilePicture { get; set; }

    public string? Name { get; set; }

    public string? Surname { get; set; }

    public string? Identifier { get; set; }
}
