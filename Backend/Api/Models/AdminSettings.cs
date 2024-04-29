namespace Api.Models;

public class Proxy
{
    public const string Name = "proxy";

    public bool ProxyAuth { get; set; }

    public bool AutoRegister { get; set; }

    public string? Header { get; set; }
}

public class Oauth
{
    public const string Name = "Oauth";

    public bool Enabled { get; set; }

    public bool AutoRegister { get; set; }

    public string? ClientId { get; set; }

    public string? ClientSecret { get; set; }

    public string? Url { get; set; }

    public string? Tokenurl { get; set; }
}
