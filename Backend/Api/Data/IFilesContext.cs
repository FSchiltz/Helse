
using Helse.Models.Common;
using Helse.Models.Files;

namespace Helse.Api.Data;

internal interface IFilesContext : IContext
{
    Task<long> CreateAsync(CreateFile file, long personId);

    Task DeleteAsync(long id, long personId);

    Task<Paginated<Helse.Models.Files.File>> GetAsync(long personId, Pagination pagination);

    Task<Helse.Models.Files.File> GetAsync(long id, long personId);

    Task<FileData> GetDataAsync(long id, long user);

    Task SaveDataAsync(long id, long personId, byte[] data);

    Task<Helse.Models.Files.File[]> GetFilesByEventAsync(long eventId, long personId);

    Task<Helse.Models.Files.File[]> GetFilesByMetricAsync(long metricId, long personId);

    Task LinkEventAsync(long eventId, long fileId, long personId);

    Task LinkMetricAsync(long metricId, long fileId, long personId);

    Task UnlinkEventAsync(long eventId, long fileId, long personId);

    Task UnlinkMetricAsync(long metricId, long fileId, long personId);

    Task UpdateAsync(UpdateFile file, long personId);
}
