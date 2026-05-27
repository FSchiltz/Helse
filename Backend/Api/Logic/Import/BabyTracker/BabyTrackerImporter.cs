using System.IO.Compression;
using System.Text.Json;
using Api.Data;
using Api.Jobs;

namespace Api.Logic.Import.BabyTracker;

public class BabyTrackerImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    public override async Task Import(IImportQueue queue, Guid id)
    {
        await using var zip = new ZipArchive(File);
        foreach (var file in zip.Entries)
        {
            queue.Progress(id, 0);
            await using var stream = await file.OpenAsync();
            var json = await JsonSerializer.DeserializeAsync<Baby>(stream);
            if (json == null)
            {
                continue;
            }

            int count = 0;
            foreach (var item in json.Records)
            {
                switch (item.Type.ToUpper())
                {
                    case "HEALTH":
                        await ImportHealth(item);
                        break;
                    case "PUMP":
                        await ImportPump(item);
                        break;
                    case "GROWTH":
                        await ImportGrowth(item);
                        break;
                    case "SLEEPING":
                        await ImportSleep(item);
                        break;
                    case "LEISURE":
                        await ImportLeisure(item);
                        break;
                    default:
                        break;
                }
                count++;
                queue.Progress(id, count / (double)json.Records.Count);
            }
        }
    }

    private async Task ImportLeisure(Record item)
    {
        throw new NotImplementedException();
    }

    private async Task ImportSleep(Record item)
    {
        throw new NotImplementedException();
    }

    private async Task ImportGrowth(Record item)
    {
        throw new NotImplementedException();
    }

    private async Task ImportPump(Record item)
    {
        throw new NotImplementedException();
    }

    private async Task ImportHealth(Record item)
    {
        throw new NotImplementedException();
    }
}
