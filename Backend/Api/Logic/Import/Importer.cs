using Api.Data;
using Api.Jobs;
using Api.Models.Events;
using Api.Models.Metrics;

namespace Api.Logic.Import;

/// <summary>
/// Base class for the importers
/// </summary>
/// <param name="db"></param>
/// <param name="user"></param>
/// <param name="patient"></param>
public abstract class Importer(IHealthContext db, long user, long patient)
{
    public abstract Task Import(IImportQueue queue, Guid id);

    protected async Task ImportEvent(CreateEvent e)
    {
        if (e.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the event exists
        var fromDb = await db.ExistsEvent(patient, e.Tag);

        if (!fromDb)
        {
            await db.Insert(e, patient, user);
        }

        await transaction.CommitAsync();
    }

    protected async Task ImportMetric(CreateMetric metric)
    {
        if (metric.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await db.ExistsMetric(patient, metric.Tag, metric.Source);

        if (!fromDb)
        {
            await db.Insert(metric, patient, user);
        }

        await transaction.CommitAsync();
    }
}