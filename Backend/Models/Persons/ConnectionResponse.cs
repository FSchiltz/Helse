namespace Helse.Models.Persons;

public record ConnectionResponse(string Id, string AccessToken, string? RefreshToken, Persons.UserType[] Roles);