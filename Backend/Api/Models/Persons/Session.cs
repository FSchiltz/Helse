namespace Api.Models.Persons;

public class Session
{
      public Guid SessionId { get; set; }

    public string? Ip { get; set; }

    public string? Location { get; set; }

    public string? UserAgent { get; set; }

    public DateTime Start { get; set; }

    public DateTime Stop { get; set; }
}
