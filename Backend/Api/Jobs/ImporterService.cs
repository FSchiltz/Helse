using Helse.Api.Data;
using Helse.Models.Imports;
using Helse.Api.Logic.Import;
using Helse.Api.Logic.Import.Redmi;
using Helse.Api.Logic.Import.Clue;
using Helse.Api.Logic.Import.BabyTracker;
using Helse.Api.Logic.Import.Google;

namespace Helse.Api.Jobs;

internal class ImporterService(IServiceProvider serviceProvider, IImportQueue queue, ILogger<ImporterService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var job = await queue.DequeueAsync(stoppingToken);
            try
            {

                using var scope = serviceProvider.CreateScope();
                var eventDb = scope.ServiceProvider.GetRequiredService<IEventContext>();
                var metricDb = scope.ServiceProvider.GetRequiredService<IMetricContext>();
                using FileImporter importer = job.Type switch
                {
                    ImportTypes.Clue => new ClueImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    ImportTypes.RedmiWatch => new RedmiWatchImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    ImportTypes.GoogleHealthConnect => new GoogleImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    ImportTypes.BabyTracker => new BabyTrackerImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    _ => throw new NotSupportedException("Invalid file type"),
                };
                queue.Start(job.Id);
                var results = await importer.Import(queue, job.Id);
                queue.Status(job.Id, $"Imported {results.Metrics.Imported} and skipped {results.Metrics.Skipped}. Imported {results.Events.Imported} and skipped {results.Events.Skipped}");
                queue.Stop(job.Id);

            }
            catch (OperationCanceledException)
            {
                queue.Cancel(job.Id);
                break;
            }
            catch (Exception ex)
            {
                queue.Error(job.Id, ex);
                logger.LogError(ex, "Error while checking events for notifications.");
            }
        }
    }

    internal record Job(Guid Id, Stream Input, ImportTypes Type, long UserId, long Patient);
}
