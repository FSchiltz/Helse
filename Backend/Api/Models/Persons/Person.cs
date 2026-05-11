using Api.Models.Settings;

namespace Api.Models.Persons;

public class Person : PersonBase
{
    public long Id { get; set; }

    public string? UserName { get; set; }

    public List<Right> Rights { get; set; } = [];

    public HashSet<UserType> Types { get; set; } = [];

    public DateTime Created { get; set; }
}
