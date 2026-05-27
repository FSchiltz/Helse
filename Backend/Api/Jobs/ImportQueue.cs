using System.Threading.Channels;
using Api.Logic.Import;
using static Api.Jobs.ImporterService;

namespace Api.Jobs;

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
         _results.Add(value.Id, new JobResult()
        {
            UserId = value.User.Id,
            Progress = 0,
            Status = JobStatus.NotStarted,
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

    public JobResult GetResult(Guid id) => _results[id];

    public JobResultInfo[] GetJobs() => [.. _results.Select(x => new JobResultInfo(x.Key, x.Value))];
}
