namespace Helse.Models.Admin;

public record OauthConnection(string Name, string Url, string ClientId, bool AutoLogin);
