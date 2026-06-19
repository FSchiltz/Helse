namespace Helse.Api.Data.Models.Persons;

[Flags]
public enum UserType
{
    Patient = 0,
    Admin = 1,
    Caregiver = 2,
    User = 4,
}