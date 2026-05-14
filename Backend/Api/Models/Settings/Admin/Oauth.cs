namespace Api.Models.Settings.Admin;

public class Oauth : IJsonSettings
{
    public static string Name => "Oauth";

    public bool Enabled { get; init; }

    public bool AutoRegister { get; init; }

    public bool AutoLogin { get; init; }

    public string? ClientId { get; init; }

    public string? ClientSecret { get; init; }

    public string? Url { get; init; }

    public string? Tokenurl { get; init; }

    public string? ClaimsUrl { get; init; }
}
