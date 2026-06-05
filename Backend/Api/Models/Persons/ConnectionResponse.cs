namespace Api.Models.Persons;

public record ConnectionResponse(string AccessToken, string? RefreshToken, Models.Persons.UserType[] Roles);