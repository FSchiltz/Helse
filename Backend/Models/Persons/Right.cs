namespace Helse.Models.Persons;

public class Right
{
    public long? PersonId { get; set; }

    public long UserId { get; set; }

    public DateTime Start { get; set; }

    public DateTime? Stop { get; set; }

    public RightType Type { get; set; }
}

