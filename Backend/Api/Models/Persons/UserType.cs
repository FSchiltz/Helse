using System.Text.Json.Serialization;

namespace Api.Models.Persons;

public enum UserType
{
    Patient = 0,
    Admin = 1,
    Caregiver = 2,
    User = 4,
}

public record ConnectionResponse(string AccessToken, string? RefreshToken, Models.Persons.UserType[] Roles);