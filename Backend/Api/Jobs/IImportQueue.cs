using static Api.Jobs.ImporterService;

namespace Api.Jobs;

public interface IImportQueue : IJobQueue<Job>
{
    void Cancel(Guid id);

    void Error(Guid id, Exception ex);

    void Status(Guid id, string status);
}