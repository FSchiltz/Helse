using Api.Data;
using Api.Data.Models;
using Api.Models;

namespace Api.Logic.Import;

public abstract class FileImporter(string file, IHealthContext db, User user) : Importer(db, user)
{
    public string File { get; } = file;
}

public abstract class Importer(IHealthContext db, Data.Models.User user)
{
    public Data.Models.User User { get; } = user;

    public abstract Task Import();

    protected async Task ImportEvent(CreateEvent e)
    {
        if (e.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the event exists
        var fromDb = await db.ExistsEvent(User.PersonId, e.Tag);

        if (!fromDb)
        {
            await db.Insert(e, User.PersonId, User.Id);
        }

        await transaction.CommitAsync();
    }

    protected async Task ImportMetric(CreateMetric metric)
    {
        if (metric.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await db.ExistsMetric(User.PersonId, metric.Tag);

        if (!fromDb)
        {
            await db.Insert(metric, User.PersonId, User.Id);
        }

        await transaction.CommitAsync();
    }
}