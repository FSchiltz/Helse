using Api.Data;
using Api.Logic;
using Api.Logic.Import;
using Api.Models;

namespace Api.Jobs;

public class ImporterService(IServiceProvider serviceProvider, IImportQueue queue, ILogger<ImporterService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var job = await queue.DequeueAsync(stoppingToken);

                using var scope = serviceProvider.CreateScope();
                var db = scope.ServiceProvider.GetRequiredService<IHealthContext>();
                Importer importer = job.Type switch
                {
                    FileTypes.Clue => new ClueImporter(job.Input, db, job.UserId, job.Patient),
                    FileTypes.RedmiWatch => new RedmiWatch(job.Input, db, job.UserId, job.Patient),
                    _ => throw new NotSupportedException("Invalid file type"),
                };
                queue.Start(job.Id);
                await importer.Import(queue, job.Id);

            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error while checking events for notifications.");
            }
        }
    }

    public record Job(Guid Id, Stream Input, FileTypes Type, long UserId, long Patient);
}
