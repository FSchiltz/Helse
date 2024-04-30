using System.Text.Json;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public interface ISettingsContext : IContext
{
    Task<T> GetSettings<T>(string name) where T : new();
    Task Upsert(string name, string data);
}

/// <summary>
/// Class for calling the database for the settings
/// </summary>
public class SettingsContext(DataConnection db) : ISettingsContext
{
    public Task<DataConnectionTransaction> BeginTransactionAsync() => db.BeginTransactionAsync();

    public Task Delete(string name) => db.GetTable<Data.Models.Settings>().DeleteAsync(x => x.Name == name);

    public async Task<T> GetSettings<T>(string name) where T : new()
    {
        var settings = await db.GetTable<Data.Models.Settings>().Where(x => x.Name == name).SingleOrDefaultAsync();
        if (settings?.Blob is null)
        {
            return new T();
        }

        return JsonSerializer.Deserialize<T>(settings.Blob) ?? new();
    }

    public Task Upsert(string name, string data)
    {
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
}
