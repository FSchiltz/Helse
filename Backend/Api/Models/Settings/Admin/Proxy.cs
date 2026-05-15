namespace Api.Models.Settings.Admin;

public class Proxy : IJsonSettings
{
    public static string Name => "proxy";

    public bool ProxyAuth { get; init; }

    public bool AutoRegister { get; init; }

    public string? Header { get; init; }
}
