namespace Helse.Api.Jobs;

/// <summary>
/// Local queue when you don't need to stream the progress
/// </summary>
internal sealed class LocalQueue : IImportQueue
{
    public void Cancel(Guid id)
    {
    }

    public ValueTask<ImporterService.Job> DequeueAsync(CancellationToken token)
    {
        throw new NotImplementedException();
    }

    public void Enqueue(ImporterService.Job value, string description)
    {
    }

    public void Error(Guid id, Exception ex)
    {
    }

    public JobResultInfo[] GetJobs()
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

    public void Status(Guid id, string status)
    {
    }

    public void Stop(Guid id)
    {
    }
}
