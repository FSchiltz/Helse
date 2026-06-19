namespace Helse.Models.Persons;

public class Session
{
  public required string SessionId { get; set; }

  public string? Ip { get; set; }

  public string? Location { get; set; }

  public string? UserAgent { get; set; }

  public DateTime Start { get; set; }

  public DateTime Stop { get; set; }
}
