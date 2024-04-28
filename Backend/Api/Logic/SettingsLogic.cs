using System.Text.Json;
using Api.Data;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Management of the sserver settings
/// </summary>
public static class SettingsLogic
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetOauthAsync(AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        return TypedResults.Ok(await db.GetSettings<Oauth>(Oauth.Name));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetProxyAsync(AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        return TypedResults.Ok(await db.GetSettings<Proxy>(Proxy.Name));
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostOauthAsync(Oauth settings, AppDataConnection db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var admin = await db.IsAdmin(context);
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
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostProxyAsync(Proxy settings, AppDataConnection db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.SaveSettingsAsync(Proxy.Name, settings);

        log.LogInformation("Proxy settings saved");

        return TypedResults.Created();
    }
}
