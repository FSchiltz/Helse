namespace Helse.Api.Data;

internal interface ISettingsContext : IContext
{
    Task Delete(string name);

    Task<T> GetSettings<T>(string name) where T : new();

    Task Upsert(string name, string data);

    Task Delete(string name, long user);

    Task<T> GetSettings<T>(string name, long user) where T : new();

    Task Upsert(string name, long user, string data);
}
