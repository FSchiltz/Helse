using Api.Data;
using Api.Jobs;
using Api.Models.Events;
using Api.Models.Imports;
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
    public abstract Task<ImportsResult> Import(IImportQueue queue, Guid id);

    protected async Task<bool> ImportEvent(CreateEvent e)
    {
        bool added = false;

        // check if the event exists
        var fromDb = await db.ExistsEvent(patient, e.Type, (int)e.Source, e.SourceId);

        if (!fromDb)
        {
            await db.Insert(e, patient, user);
            added = true;
        }
        else
        {
            // TODO update
        }

        return added;
    }

    protected async Task<bool> ImportMetric(CreateMetric metric)
    {
        bool added = false;

        // check if the metric exists
        var fromDb = await db.ExistsMetric(patient, metric.Type, (int)metric.Source, metric.SourceId);

        if (!fromDb)
        {
            await db.Insert(metric, patient, user);
            added = true;
        }
        else
        {
            // TODO update
        }

        return added;
    }
}