using Api.Data;
using Api.Data.Models;
using Api.Logic.Import;


namespace Api.Logic.Import;

public class ListImporter(ImportData file, IHealthContext db, User user) : Importer(db, user)
{
    public ImportData Data { get; } = file;

    public override async Task Import()
    {
        if (Data.Metrics is not null)
            foreach (var metric in Data.Metrics)
            {
                await ImportMetric(metric);
            }

        if (Data.Events is not null)
            foreach (var value in Data.Events)
            {
                await ImportEvent(value);
            }
    }
}