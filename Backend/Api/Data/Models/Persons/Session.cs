using LinqToDB.Mapping;

namespace Api.Data.Models.Persons;

[Table(Schema = "person")]
public class Session
{
    public long UserId { get; set; }

    public Guid SessionId { get; set; }

    public string? Ip { get; set; }

    public string? Location { get; set; }

    public string? UserAgent { get; set; }

    public DateTime Start { get; set; }

    public DateTime Stop { get; set; }
}
