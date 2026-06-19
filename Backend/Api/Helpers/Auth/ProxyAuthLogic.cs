using System.Security.Cryptography;
using Helse.Api.Data;
using Helse.Models.Persons;
using Helse.Models.Settings.Admin;

namespace Helse.Api.Helpers.Auth;

internal static class ProxyAuthHelper
{
    private static string SanitizeForLog(string? value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        var sanitized = value.Replace("\r", "\\r").Replace("\n", "\\n");
        return new string(sanitized.Where(c => !char.IsControl(c) || c == '\\').ToArray());
    }

    private static string SanitizeHeadersForLog(IHeaderDictionary headers)
    {
        return string.Join(", ", headers.Select(h => $"{SanitizeForLog(h.Key)}={SanitizeForLog(h.Value.ToString())}"));
    }

    public static async Task<(bool, Data.Models.Persons.User?)> ConnectHeader(IUserContext db, HttpContext context, Proxy settings, ILogger log)
    {
        if (settings.Header is null)
        {
            return (false, null);
        }

        log.LogInformation("Connexion by proxy tentative using {Header} in {Headers}", settings.Header, SanitizeHeadersForLog(context.Request.Headers));
        context.Request.Headers.TryGetValue(settings.Header, out var headers);
        var header = headers.FirstOrDefault();

        if (header is not null)
        {
            log.LogInformation("Connexion by proxy auth header {Header} and user {User}", settings.Header, SanitizeForLog(header));
        }
        else
        {
            log.LogWarning("Connexion by proxy auth header {Header} rejected", settings.Header);
            return (false, null);
        }

        var fromDb = await db.Get(header);

        var logged = false;
        if (fromDb is null)
        {
            if (settings.AutoRegister)
            {
                log.LogInformation("User created for proxy header {Header} and user {User}", settings.Header, SanitizeForLog(header));
                // If auto register and not found, we create it
                await db.CreateUserAsync(new PersonCreation
                {
                    UserName = header,
                    Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                    Types = [UserType.User],
                }, 0);
                logged = true;
                fromDb = await db.Get(header);
            }
        }
        else
        {
            logged = true;
        }

        return (logged, fromDb);
    }
}
