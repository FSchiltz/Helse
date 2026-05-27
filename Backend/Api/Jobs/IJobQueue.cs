namespace Api.Jobs;

public interface IJobQueue<T>
{
    void Enqueue(T value);

    ValueTask<T> DequeueAsync(CancellationToken token);

    void Start(Guid id);

    void Stop(Guid id);

    void Progress(Guid id, double progress);

    JobResult GetResult(Guid id);
}
