namespace Helse.Models.Persons;

public class UpdatePerson : PersonBase
{
    public long Id { get; set; }

    public HashSet<UserType>? Types { get; set; }
}