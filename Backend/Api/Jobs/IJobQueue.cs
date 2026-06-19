namespace Helse.Api.Jobs;

public interface IJobQueue<T>
{
    void Enqueue(T value, string description);

    ValueTask<T> DequeueAsync(CancellationToken token);

    void Start(Guid id);

    void Stop(Guid id);

    void Progress(Guid id, double progress);

    JobResult GetResult(Guid id);

    JobResultInfo[] GetJobs();
}
