
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
            await db.Save(settings.Oauth);
        else
            await db.Delete(Oauth.Name);

        await transaction.CommitAsync();

        return TypedResults.Created();
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="oauth"></param>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostOauthAsync(Oauth oauth, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.Save(oauth);

        return TypedResults.Created();
    }

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

        var oauth = await db.GetTable<Data.Models.Settings>().FirstOrDefaultAsync(x => x.Name == nameof(Oauth));
        if (oauth is null)
            return TypedResults.NotFound();

        return TypedResults.Ok(JsonSerializer.Deserialize<Oauth>(oauth.Blob));
    }
}