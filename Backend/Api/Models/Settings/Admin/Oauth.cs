namespace Api.Models.Settings.Admin;

public class Oauth
{
    public const string Name = "Oauth";

    public bool Enabled { get; set; }

    public bool AutoRegister { get; set; }

    public bool AutoLogin { get; set; }

    public string? ClientId { get; set; }

    public string? ClientSecret { get; set; }

    public string? Url { get; set; }

    public string? Tokenurl { get; set; }
}
