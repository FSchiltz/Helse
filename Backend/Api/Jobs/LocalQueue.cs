using static Api.Jobs.ImporterService;

namespace Api.Jobs;

/// <summary>
/// Local queue when you don't need to stream the progress
/// </summary>
public sealed class LocalQueue : IImportQueue
{
    public ValueTask<Job> DequeueAsync(CancellationToken token)
    {
        throw new NotImplementedException();
    }

    public void Enqueue(Job value)
    {
        throw new NotImplementedException();
    }

    public JobResult GetResult(Guid id)
    {
        throw new NotImplementedException();
    }

    public void Progress(Guid id, double progress)
    {
    }

    public void Start(Guid id)
    {
    }

    public void Stop(Guid id)
    {
    }
}
