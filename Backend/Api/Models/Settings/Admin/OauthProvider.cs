namespace Api.Models.Settings.Admin;

public class OauthProvider
{
    public required string Name { get; init; }

    public bool AutoRegister { get; init; }

    public bool AutoLogin { get; init; }

    public required string ClientId { get; init; }

    public required string ClientSecret { get; init; }

    public required string Url { get; init; }

    public required string Tokenurl { get; init; }

    public required string ClaimsUrl { get; init; }
}
