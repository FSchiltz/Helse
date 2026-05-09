using Api.Models.Settings;

namespace Api.Models.Persons;

public abstract class PersonBase
{
    public string? Name { get; set; }

    public string? Surname { get; set; }

    public string? Identifier { get; set; }

    public DateTime? Birth { get; set; }

    public byte[]? ProfilePicture { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }
}
