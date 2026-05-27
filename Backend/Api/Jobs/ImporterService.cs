using System.Threading.Channels;
using Api.Data;
using Api.Logic;
using Api.Logic.Import;
using Api.Models;
using static Api.Jobs.ImporterService;

namespace Api.Jobs;

public interface IImportQueue : IJobQueue<Job>;

public sealed class ImportQueue : IImportQueue
{
    private readonly Channel<Job> _queue = Channel.CreateUnbounded<Job>();

    private readonly Dictionary<Guid, JobResult> _results = [];

    public ValueTask<Job> DequeueAsync(CancellationToken token)
    {
        return _queue.Reader.ReadAsync(token);
    }

    public void Enqueue(Job value)
    {
        _queue.Writer.TryWrite(value);
    }

    public void Progress(Guid id, double progress)
    {
        ArgumentOutOfRangeException.ThrowIfGreaterThan(progress, 100);

        _results[id].Progress = progress;
    }

    public void Start(Guid id)
    {
        _results[id].Status = JobStatus.InProgress;
        _results[id].Progress = 0;
    }

    public void Stop(Guid id)
    {
        _results[id].Status = JobStatus.Done;
        _results[id].Progress = 100;
    }

    public void Error(Guid id, Exception error)
    {
        _results[id].Status = JobStatus.InError;
        _results[id].Error = error;
    }

    public JobResult GetResult(Guid id)
    {
        return _results[id];
    }
}

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
                    FileTypes.Clue => new ClueImporter(job.Input.File ?? throw new InvalidDataException(), db, job.User),
                    FileTypes.RedmiWatch => new RedmiWatch(job.Input.File ?? throw new InvalidDataException(), db, job.User),
                    FileTypes.Bulk => new ListImporter(job.Input.Data ?? throw new InvalidDataException(), db, job.User),
                    _ => throw new NotSupportedException("Invalid file type"),
                };
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

    public record Job(Guid Id, Input Input, FileTypes Type, Data.Models.User User);

    public record Input(IFormFile? File, ImportData? Data);
}
