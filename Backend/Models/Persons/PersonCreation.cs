namespace Helse.Models.Persons;

public class PersonCreation : PersonBase
{
    public string? UserName { get; set; }

    public string? Password { get; set; }

    public HashSet<UserType> Types { get; set; } = [];
}
