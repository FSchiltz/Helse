namespace Helse.Models.Admin;

public record Status(bool Init, bool ExternalAuth, string? Error, OauthConnection[] Oauths);