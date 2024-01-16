using System.Text.Json;
using Api.Models;
using LinqToDB;

namespace Api.Data;

/// <summary>
/// Class for calling the database for the settings
/// </summary>
public static class SettingsExtension
{
    public static Task Save<T>(this AppDataConnection db,string name, T blob)
    {
        var data = JsonSerializer.Serialize(blob);

        return db.GetTable<Data.Models.Settings>().InsertOrUpdateAsync(() => new Data.Models.Settings
        {
            Name = name,
            Blob = data,
        },
         (x) => new Data.Models.Settings
         {
             Name = name,
             Blob = data,
         });
    }

    public static Task Delete(this AppDataConnection db, string name) => db.GetTable<Data.Models.Settings>().DeleteAsync(x => x.Name == name);
}