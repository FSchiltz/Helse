using System.Text.Json;
using Api.Data;

namespace Api.Helpers;

public static class SettingsHelper
{

    public static async Task SaveSettingsAsync<T>(this ISettingsContext db, string name, T blob) where T : class
    {
        await using var transaction = await db.BeginTransactionAsync();

        var data = JsonSerializer.Serialize(blob);

        await db.Upsert(name, data);

        await transaction.CommitAsync();
    }
}
