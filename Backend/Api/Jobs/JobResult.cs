using Helse.Api.Logic.Import;

namespace Helse.Api.Jobs;

internal record JobResultInfo(Guid Id, JobResult Result);

internal class JobResult
{
    public required string Description { get; set; }

    public required long UserId { get; set; }

    public double Progress { get; set; }

    public JobStatus Status { get; set; }

    public string? Error { get; set; }

    public required DateTime Start { get; set; }

    public required DateTime Enque { get; set; }

    public DateTime? Stop { get; set; }

    /// <summary>
    /// Job result
    /// </summary>
    public string? Result { get; set; }
}
