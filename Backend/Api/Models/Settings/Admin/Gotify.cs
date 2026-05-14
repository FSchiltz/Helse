namespace Api.Models.Settings.Admin;

public class Gotify : IJsonSettings
{
    public static string Name => "Gotify";

    public bool Enabled { get; init; }

    public string? Url { get; init; }

    public string? Token { get; init; }
}
