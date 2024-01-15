namespace Api.Models;

public class Settings
{
    public Oauth? Oauth { get; set; }
}

public class Oauth
{
    public const string Name = "Oauth";

    public bool Enabled { get; set; }

    public bool AutoRegister { get; set; }

    public string? ClientId { get; set; }

    public string? ClientSecret { get; set; }
}
