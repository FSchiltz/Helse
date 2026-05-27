using Api.Logic.Import;

namespace Api.Jobs;

public class JobResult
{
    public required long UserId { get; set; }

    public double Progress { get; set; }

    public JobStatus Status { get; set; }

    public Exception? Error { get; set; }
}
