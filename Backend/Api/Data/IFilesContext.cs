
using Helse.Models.Files;

namespace Helse.Api.Data;

internal interface IFilesContext : IContext
{
    Task CreateAsync(CreateFile file, long v);

    Task DeleteAsync(long id, long personId);

    Task<Helse.Models.Files.File[]> GetAsync(long personId);
    Task<Helse.Models.Files.File[]> GetFilesByEventAsync(long eventId, long user);
    Task<Helse.Models.Files.File[]> GetFilesByMetricAsync(long metricId, long user);
    Task LinkEventAsync(long eventId, long fileId, long user);
    Task LinkMetricAsync(long metricId, long fileId, long user);
    Task UnlinkEventAsync(long eventId, long fileId, long user);
    Task UnlinkMetricAsync(long metricId, long fileId, long user);
    Task UpdateAsync(UpdateFile file, long v);
}
