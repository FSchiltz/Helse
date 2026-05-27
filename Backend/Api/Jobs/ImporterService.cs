using Api.Data;
using Api.Logic;
using Api.Logic.Import;
using Api.Logic.Import.BabyTracker;
using Api.Logic.Import.Clue;
using Api.Logic.Import.Redmi;
using Api.Models;
using LinqToDB.Tools;

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
                var db = scope.ServiceProvider.GetRequiredService<IHealthContext>();
                Importer importer = job.Type switch
                {
                    FileTypes.Clue => new ClueImporter(job.Input, db, job.UserId, job.Patient),
                    FileTypes.RedmiWatch => new RedmiWatch(job.Input, db, job.UserId, job.Patient),
                    FileTypes.GoogleHealthConnect => new GoogleImporter(job.Input, db, job.UserId, job.Patient),
                    FileTypes.BabyTracker => new BabyTrackerImporter(job.Input, db, job.UserId, job.Patient),
                    _ => throw new NotSupportedException("Invalid file type"),
                };
                queue.Start(job.Id);
                await importer.Import(queue, job.Id);
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
