using Helse.Api.Data;
using Helse.Api.Jobs;
using Helse.Models.Imports;

namespace Helse.Api.Logic.Import;

internal class ListImporter(ImportData file, IEventContext eventDb, IMetricContext metricDb, long user, long patient) : Importer(eventDb, metricDb, user, patient)
{
    public ImportData Data { get; } = file;

    public override async Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        ImportResult metrics;
        if (Data.Metrics is not null)
        {
            int i = 0;
            long adds = 0;
            long skips = 0;
            foreach (var metric in Data.Metrics)
            {
                var added = await ImportMetric(metric);
                if (added)
                {
                    adds++;
                }
                else
                {
                    skips++;
                }
                queue.Progress(id, i / Data.Metrics.Count * 100 / 2);
                i++;
            }
            metrics = new(adds, skips, 0);
        }
        else
        {
            queue.Progress(id, 50);
            metrics = new(0, 0, 0);
        }

        ImportResult events;
        if (Data.Events is not null)
        {
            int i = 0;
            long adds = 0;
            long skips = 0;
            foreach (var value in Data.Events)
            {
                var added = await ImportEvent(value);
                if (added)
                {
                    adds++;
                }
                else
                {
                    skips++;
                }
                queue.Progress(id, (i / Data.Events.Count * 100 / 2) + 50);
                i++;
            }
            events = new(adds, skips, 0);
        }
        else
        {
            events = new(0, 0, 0);
        }

        queue.Stop(id);
        return new(metrics, events);
    }
}