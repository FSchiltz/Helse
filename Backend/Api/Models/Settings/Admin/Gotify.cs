namespace Api.Models.Settings.Admin;

public class Gotify
{
    public const string Name = "Gotify";

    public bool Enabled { get; set; }

    public string? Url { get; set; }

    public string? Token { get; set; }
}
