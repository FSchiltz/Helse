using System.Text.Json;
using Api.Data;
using Api.Helpers;
using Api.Models.Settings.Admin;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Api.Logic;

/// <summary>
/// Management of the server settings
/// </summary>
public static class SettingsLogic
{
    /// <summary>
    /// Get the Oauth settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetOauthAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Oauth>(Oauth.Name));
    }

    /// <summary>
    /// Get the proxy auth settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetProxyAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Proxy>(Proxy.Name));
    }

    /// <summary>
    /// Update the Oauth settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostOauthAsync(Oauth settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Update the auth proxy settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostProxyAsync(Proxy settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Get the smtp settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetSmtpAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Smtp>(Smtp.Name));
    }

    /// <summary>
    /// Update the smtp settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostSmtpAsync(Smtp settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Get the gotify settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetGotifyAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Gotify>(Gotify.Name));
    }

    /// <summary>
    /// Update the gotify settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostGotifyAsync(Gotify settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    private static async Task<Created> Save<T>(this ISettingsContext db, T settings, ILogger log)
    where T : IJsonSettings
    {
        var data = JsonSerializer.Serialize(settings);
        await db.Upsert(T.Name, data);

        log.LogInformation("Settings saved");
        return TypedResults.Created();
    }
}
