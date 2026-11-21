namespace Helse.Models.Persons;

public class UpdatePerson : PersonBase
{
    public long Id { get; set; }

    public byte[]? ProfilePicture { get; set; }

    public HashSet<UserType>? Types { get; set; }
}