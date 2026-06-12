using Api.Data;
using Api.Logic.Import;
using Api.Logic.Import.BabyTracker;
using Api.Logic.Import.Clue;
using Api.Logic.Import.Google;
using Api.Logic.Import.Redmi;
using Api.Models.Imports;

namespace Api.Jobs;

public class ImporterService(IServiceProvider serviceProvider, IImportQueue queue, ILogger<ImporterService> logger) : BackgroundService
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
                Importer importer = job.Type switch
                {
                    FileTypes.Clue => new ClueImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    FileTypes.RedmiWatch => new RedmiWatchImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    FileTypes.GoogleHealthConnect => new GoogleImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
                    FileTypes.BabyTracker => new BabyTrackerImporter(job.Input, eventDb, metricDb, job.UserId, job.Patient),
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

    public record Job(Guid Id, Stream Input, FileTypes Type, long UserId, long Patient);
}
