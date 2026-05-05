namespace Api.Models.Settings.Admin;

public class Proxy
{
    public const string Name = "proxy";

    public bool ProxyAuth { get; set; }

    public bool AutoRegister { get; set; }

    public string? Header { get; set; }
}
