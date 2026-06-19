using System.Threading.Channels;
using Api.Logic.Import;

namespace Helse.Api.Jobs;

internal sealed class ImportQueue : IImportQueue
{
    private readonly Channel<ImporterService.Job> _queue = Channel.CreateUnbounded<ImporterService.Job>();

    private readonly Dictionary<Guid, JobResult> _results = [];

    public ValueTask<ImporterService.Job> DequeueAsync(CancellationToken token)
    {
        return _queue.Reader.ReadAsync(token);
    }

    public void Enqueue(ImporterService.Job value, string description)
    {
        _queue.Writer.TryWrite(value);
        _results.Add(value.Id, new JobResult()
        {
            UserId = value.UserId,
            Progress = 0,
            Status = JobStatus.NotStarted,
            Start = DateTime.MinValue,
            Description = description,
        });
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
        _results[id].Start = DateTime.Now;
    }

    public void Stop(Guid id)
    {
        _results[id].Status = JobStatus.Done;
        _results[id].Progress = 100;
        _results[id].Stop = DateTime.Now;
    }

    public void Error(Guid id, Exception error)
    {
        _results[id].Status = JobStatus.InError;
        _results[id].Error = error.Message;
        _results[id].Stop = DateTime.Now;
    }

    public JobResult GetResult(Guid id) => _results[id];

    public JobResultInfo[] GetJobs() => [.. _results.Select(x => new JobResultInfo(x.Key, x.Value))];

    public void Cancel(Guid id)
    {
        _results[id].Status = JobStatus.Cancel;
        _results[id].Stop = DateTime.Now;
    }

    public void Status(Guid id, string status)
    {
        _results[id].Result = status;
    }
}
