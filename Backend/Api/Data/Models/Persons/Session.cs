using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
internal class Sessions
{
    [Column, NotNull]
    public long UserId { get; set; }

    [Column, NotNull]
    public required string SessionId { get; set; }

    [Column, Nullable]
    public string? Ip { get; set; }

    [Column, Nullable]
    public string? Location { get; set; }

    [Column, Nullable]
    public string? UserAgent { get; set; }

    [Column, NotNull]
    public DateTime Start { get; set; }

    [Column, NotNull]
    public DateTime Stop { get; set; }
}
