using System.Text.Json.Serialization;

namespace Api.Models;

[JsonConverter(typeof(JsonStringEnumConverter))]
[Flags]
public enum UserType
{
    Patient = 0,
    Admin = 1,
    Caregiver = 2,
    User = 4,
    CareWithSelf = User | Caregiver,
    Superuser = Admin | User | Caregiver,
}