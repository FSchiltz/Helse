namespace Helse.Api.Jobs;

internal interface IImportQueue : IJobQueue<ImporterService.Job>
{
    void Cancel(Guid id);

    void Error(Guid id, Exception ex);

    void Status(Guid id, string status);
}