using Api.Data;
using Api.Models;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Logic.Import;

public abstract class FileImporter(string file, IHealthContext db, Data.Models.User user)
{
    public string File { get; } = file;

    public Data.Models.User User { get; } = user;

    public abstract Task Import();

    protected async Task ImportEvent(CreateEvent e, long person, long user)
    {
        await using var transaction = await db.BeginTransactionAsync();

        // check if the event exists
        var fromDb = await db.ExistsEvent(person, e.Tag);

        if (!fromDb)
        {
            await db.Insert(e, person, user);
        }

        await transaction.CommitAsync();
    }

    protected async Task ImportMetric(CreateMetric metric, long person, long user)
    {
        await using var transaction = await db.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await db.ExistsMetric(person, metric.Tag);

        if (!fromDb)
        {
            await db.Insert(metric, person, user);
        }

        await transaction.CommitAsync();
    }
}