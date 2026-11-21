namespace Helse.Models.Persons;

public abstract class PersonBase
{
    public string? Name { get; set; }

    public string? Surname { get; set; }

    public string? Identifier { get; set; }

    public DateTime? Birth { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }
}
