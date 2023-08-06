using Api.Data.Models;

namespace Api.Models;

public class Person
{
    public string? Name { get; set; }

    public string? Surname { get; set; }
 
    public string? Identifier { get; set; }

    public DateTime? Birth { get; set; }

    public string? UserName { get; set; }

    public string? Password { get; set; }

    public UserType Type { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public List<Right> Rights { get; set; } = new List<Right>();
}