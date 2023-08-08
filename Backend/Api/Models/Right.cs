namespace Api.Models;

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
    public static Right FromDb(this Api.Data.Models.Right x) => new()
    {
        Stop = x.Stop,
        PersonId = x.PersonId,
        Start = x.Start,
        Type = (Models.RightType)x.Type,
        UserId = x.UserId
    };
}
