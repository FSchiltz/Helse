using Helse.Api.Data;
using Helse.Api.Jobs;
using Helse.Models.Events;
using Helse.Models.Imports;
using Helse.Models.Metrics;

namespace Helse.Api.Logic.Import;

/// <summary>
/// Base class for the importers
/// </summary>
/// <param name="user"></param>
/// <param name="patient"></param>
internal abstract class Importer(IEventContext eventDb, IMetricContext metricDb , long user, long patient)
{
    public abstract Task<ImportsResult> Import(IImportQueue queue, Guid id);

    protected async Task<bool> ImportEvent(CreateEvent e)
    {
        bool added = false;

        // check if the event exists
        var fromDb = await eventDb.ExistsEvent(patient, e.Type, (int)e.Source, e.SourceId);

        if (!fromDb)
        {
            await eventDb.Insert(e, patient, user);
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
        var fromDb = await metricDb.ExistsMetric(patient, metric.Type, (int)metric.Source, metric.SourceId);

        if (!fromDb)
        {
            await metricDb.Insert(metric, patient, user);
            added = true;
        }
        else
        {
            // TODO update
        }

        return added;
    }
}