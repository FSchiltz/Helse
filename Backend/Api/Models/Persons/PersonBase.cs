using Api.Models.Settings;

namespace Api.Models.Persons;

public abstract class PersonBase
{
    public string? Name { get; set; }

    public string? Surname { get; set; }

    public string? Identifier { get; set; }

    public DateTime? Birth { get; set; }

    public string? UserName { get; set; }

    public string? Password { get; set; }

    public HashSet<UserType> Types { get; set; } = [];

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public List<Right> Rights { get; set; } = [];
}
