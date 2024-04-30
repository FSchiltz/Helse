using System.Text.Json;
using LinqToDB;

namespace Api.Data;

/// <summary>
/// Class for calling the database for the settings
/// </summary>
public static class SettingsExtension
{
    static public async Task SaveSettingsAsync<T>(this IDataContext db, string name, T blob) where T : class
    {
        using var transaction = await db.BeginTransactionAsync();

        var data = JsonSerializer.Serialize(blob);

        await db.GetTable<Data.Models.Settings>().InsertOrUpdateAsync(() => new Data.Models.Settings
        {
            Name = name,
            Blob = data,
        },
         (x) => new Data.Models.Settings
         {
             Name = name,
             Blob = data,
         });


        await transaction.CommitAsync();
    }

    public static Task Delete(this IDataContext db, string name) => db.GetTable<Data.Models.Settings>().DeleteAsync(x => x.Name == name);

    public static async Task<T> GetSettings<T>(this IDataContext db, string name) where T : new()
    {
        var settings = await db.GetTable<Data.Models.Settings>().Where(x => x.Name == name).SingleOrDefaultAsync();
        if (settings?.Blob is null)
        {
            return new T();
        }

        return JsonSerializer.Deserialize<T>(settings.Blob) ?? new();
    }
}