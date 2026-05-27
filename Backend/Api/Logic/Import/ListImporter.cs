using Api.Data;
using Api.Data.Models;
using Api.Jobs;

namespace Api.Logic.Import;

public class ListImporter(ImportData file, IHealthContext db, User user) : Importer(db, user)
{
    public ImportData Data { get; } = file;

    public override async Task Import(IImportQueue queue, Guid id)
    {
        if (Data.Metrics is not null)
        {
            int i = 0;
            foreach (var metric in Data.Metrics)
            {
                await ImportMetric(metric);
                queue.Progress(id, i / Data.Metrics.Count * 100 / 2);
                i++;
            }
        }
        else
        {
            queue.Progress(id, 50);
        }

        if (Data.Events is not null)
        {
            int i = 0;
            foreach (var value in Data.Events)
            {
                await ImportEvent(value);
                queue.Progress(id, (i / Data.Events.Count * 100 / 2) + 50);
                i++;
            }
        }

        queue.Stop(id);
    }
}