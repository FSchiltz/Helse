using LinqToDB.Mapping;

namespace Api.Data.Models.Persons;

[Table(Schema = "person")]
public class OauthUser
{
    [Column, NotNull]
    public long UserId { get; set; }

    [Column, NotNull]
    public required string OauthSub { get; set; }

    [Column, NotNull]
    public required string Provider { get; set; }
}
