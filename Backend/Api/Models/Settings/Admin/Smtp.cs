namespace Api.Models.Settings.Admin;

public sealed record Smtp : IJsonSettings
{
    public static string Name => "smtp";

    public bool Enabled { get; init; }

    public string SmtpHost { get; init; } = string.Empty;

    public int SmtpPort { get; init; } = 587;

    public bool EnableSsl { get; init; } = true;

    public string FromEmail { get; init; } = string.Empty;

    public string? UserName { get; init; }

    public string? Password { get; init; }
}