using System.Security.Cryptography;
using Api.Data;
using Api.Models.Persons;
using Api.Models.Settings.Admin;

namespace Api.Helpers.Auth;

public static class ProxyAuthHelper
{
    public static async Task<(bool, Data.Models.Persons.User?)> ConnectHeader(IUserContext db, HttpContext context, Proxy settings, ILogger log)
    {
        if (settings.Header is null)
        {
            return (false, null);
        }

        log.LogInformation("Connexion by proxy tentative using {header} in {headers}", settings.Header, context.Request.Headers);
        context.Request.Headers.TryGetValue(settings.Header, out var headers);
        var header = headers.FirstOrDefault();

        if (header is not null)
        {
            log.LogInformation("Connexion by proxy auth header {header} and user {user}", settings.Header, header);
        }
        else
        {
            log.LogWarning("Connexion by proxy auth header {header} rejected", settings.Header);
            return (false, null);
        }

        var fromDb = await db.Get(header);

        var logged = false;
        if (fromDb is null)
        {
            if (settings.AutoRegister)
            {
                log.LogInformation("User created for {header}", context.Request.Headers);
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
