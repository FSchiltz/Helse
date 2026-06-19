using LinqToDB.Mapping;

namespace Helse.Api.Data.Models.Persons;

[Table(Schema = "person")]
internal class OauthUser
{
    [Column, NotNull]
    public long UserId { get; set; }

    [Column, NotNull]
    public required string OauthSub { get; set; }

    [Column, NotNull]
    public required string Provider { get; set; }
}
