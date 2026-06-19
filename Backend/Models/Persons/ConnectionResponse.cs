namespace Helse.Models.Persons;

public record ConnectionResponse(string AccessToken, string? RefreshToken, Persons.UserType[] Roles);