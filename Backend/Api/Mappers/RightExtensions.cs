using Helse.Models.Persons;

namespace Helse.Api.Mappers;

internal static class RightExtensions
{
    public static Right FromDb(this Helse.Api.Data.Models.Persons.Right x) => new()
    {
        Stop = x.Stop,
        PersonId = x.PersonId,
        Start = x.Start,
        Type = (RightType)x.Type,
        UserId = x.UserId
    };
}