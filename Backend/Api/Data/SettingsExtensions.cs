using System.Text.Json;
using Api.Models;
using LinqToDB;

namespace Api.Data;

/// <summary>
/// Class for calling the database for the settings
/// </summary>
public static class SettingsExtension
{
    public static Task Save(this AppDataConnection db, Oauth oauth)
    {
        var data = JsonSerializer.Serialize(oauth);

        return db.GetTable<Data.Models.Settings>().InsertOrUpdateAsync(() => new Data.Models.Settings
        {
            Name = Oauth.Name,
            Blob = data,
        },
         (x) => new Data.Models.Settings
         {
             Name = Oauth.Name,
             Blob = data,
         });
    }

    public static Task Delete(this AppDataConnection db, string name) => db.GetTable<Data.Models.Settings>().DeleteAsync(x => x.Name == name);
}