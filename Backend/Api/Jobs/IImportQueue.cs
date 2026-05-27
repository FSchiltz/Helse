using static Api.Jobs.ImporterService;

namespace Api.Jobs;

public interface IImportQueue : IJobQueue<Job>;
