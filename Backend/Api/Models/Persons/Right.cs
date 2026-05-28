namespace Api.Models.Persons;

public class Right
{
    public long? PersonId { get; set; }

    public long UserId { get; set; }

    public DateTime Start { get; set; }

    public DateTime? Stop { get; set; }

    public RightType Type { get; set; }
}

public static class RightExtensions
{
    public static Right FromDb(this Data.Models.Persons.Right x) => new()
    {
        Stop = x.Stop,
        PersonId = x.PersonId,
        Start = x.Start,
        Type = (RightType)x.Type,
        UserId = x.UserId
    };
}
