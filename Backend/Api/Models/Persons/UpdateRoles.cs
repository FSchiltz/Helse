namespace Api.Models.Persons;

public class UpdateRoles
{
    public long PersonId { get; set; }

    public List<UserType> Roles { get; set; } = [];
}