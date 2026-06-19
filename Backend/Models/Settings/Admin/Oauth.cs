namespace Helse.Models.Settings.Admin;

public class Oauth : IJsonSettings
{
    public static string Name => "Oauth";

    public bool Enabled { get; init; }

    public OauthProvider[] Providers { get; init; } = [];
}
