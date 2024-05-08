using Api.Data;
using Api.Helpers;
using Api.Models;

namespace Api.Logic;

/// <summary>
/// Management of the sserver settings
/// </summary>
public static class SettingsLogic
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetOauthAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        return TypedResults.Ok(await settings.GetSettings<Oauth>(Oauth.Name));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetProxyAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        return TypedResults.Ok(await settings.GetSettings<Proxy>(Proxy.Name));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostOauthAsync(Oauth settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.SaveSettingsAsync(Oauth.Name, settings);

        log.LogInformation("Oauth settings saved");

        return TypedResults.Created();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostProxyAsync(Proxy settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.SaveSettingsAsync(Proxy.Name, settings);

        log.LogInformation("Proxy settings saved");

        return TypedResults.Created();
    }
}
