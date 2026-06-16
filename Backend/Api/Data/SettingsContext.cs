using System.Text.Json;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public interface ISettingsContext : IContext
{
    Task Delete(string name);

    Task<T> GetSettings<T>(string name) where T : new();

    Task Upsert(string name, string data);

    Task Delete(string name, long user);

    Task<T> GetSettings<T>(string name, long user) where T : new();

    Task Upsert(string name, long user, string data);
}

/// <summary>
/// Class for calling the database for the settings
/// </summary>
public class SettingsContext(DataConnection db, SlowQueryLogInterceptor interceptor) : BaseContext(db, interceptor), ISettingsContext
{
    public Task Delete(string name) => Db.GetTable<Data.Models.Admin.Settings>().DeleteAsync(x => x.Name == name);

    public async Task<T> GetSettings<T>(string name) where T : new()
    {
        var settings = await Db.GetTable<Data.Models.Admin.Settings>().Where(x => x.Name == name).SingleOrDefaultAsync();
        if (settings?.Blob is null)
        {
            return new T();
        }

        return JsonSerializer.Deserialize<T>(settings.Blob) ?? new();
    }

    public Task Upsert(string name, string data)
    {
        return Db.GetTable<Data.Models.Admin.Settings>().InsertOrUpdateAsync(() => new Data.Models.Admin.Settings
        {
            Name = name,
            Blob = data,
        },
         (x) => new Data.Models.Admin.Settings
         {
             Name = name,
             Blob = data,
         });
    }

    public Task Delete(string name, long user) => Db.GetTable<Data.Models.Persons.Settings>().DeleteAsync(x => x.Name == name && x.Id == user);

    public async Task<T> GetSettings<T>(string name, long user) where T : new()
    {
        var settings = await Db.GetTable<Data.Models.Persons.Settings>().Where(x => x.Name == name && x.Id == user).SingleOrDefaultAsync();
        if (settings?.Blob is null)
        {
            return new T();
        }

        return JsonSerializer.Deserialize<T>(settings.Blob) ?? new();
    }

    public async Task Upsert(string name, long user, string data)
    {
        await using var transaction = await BeginTransactionAsync();
        await Delete(name, user);
        await Db.GetTable<Data.Models.Persons.Settings>().InsertAsync(() => new Data.Models.Persons.Settings
        {
            Name = name,
            Blob = data,
            Id = user,
        });

        await transaction.CommitAsync();
    }
}
