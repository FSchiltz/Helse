namespace Api.Models.Settings.Admin;

public sealed record Smtp
{
    public const string Name = "smtp";
    
    public string SmtpHost { get; init; } = string.Empty;
    public int SmtpPort { get; init; } = 587;
    public bool EnableSsl { get; init; } = true;
    public string FromEmail { get; init; } = string.Empty;
    public string? UserName { get; init; }
    public string? Password { get; init; }
    public int PollingSeconds { get; init; } = 60;
    public int StartingWindowMinutes { get; init; } = 15;
}