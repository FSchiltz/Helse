using Api.Logic.Import;

namespace Api.Jobs;

public record JobResultInfo(Guid Id, JobResult Result);

public class JobResult
{
    public required string Description { get; set; }
    public required long UserId { get; set; }

    public double Progress { get; set; }

    public JobStatus Status { get; set; }

    public Exception? Error { get; set; }

    public required DateTime Start { get; set; }

    public DateTime? Stop { get; set; }
}
