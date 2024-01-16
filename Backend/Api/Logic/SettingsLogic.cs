
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
    public static async Task<IResult> GetSettingsAsync(AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        var settings = new Settings();

        await foreach (var setting in db.GetTable<Data.Models.Settings>().AsAsyncEnumerable())
        {
            switch (setting.Name)
            {
                case Oauth.Name:
                    settings.Oauth = JsonSerializer.Deserialize<Oauth>(setting.Blob);
                    break;
                case Proxy.Name:
                    settings.Proxy = JsonSerializer.Deserialize<Proxy>(setting.Blob);
                    break;
            }
        }

        return TypedResults.Ok(settings);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostSettingAsync(Settings settings, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        using var transaction = await db.BeginTransactionAsync();

        if (settings.Oauth is not null)
            await db.Save(Oauth.Name, settings.Oauth);
        else
            await db.Delete(Oauth.Name);

        if (settings.Proxy is not null)
            await db.Save(Proxy.Name, settings.Proxy);
        else
            await db.Delete(Proxy.Name);

        await transaction.CommitAsync();

        return TypedResults.Created();
    }
}
