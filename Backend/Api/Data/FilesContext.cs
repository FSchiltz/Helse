using Helse.Api.Data.Models.File;
using Helse.Models.Common;
using Helse.Models.Files;
using LinqToDB;
using LinqToDB.Async;
using LinqToDB.Data;

namespace Helse.Api.Data;

internal class FilesContext(DataConnection db, SlowQueryLogInterceptor interceptor)
: BaseContext(db, interceptor), IFilesContext
{
    public Task<long> CreateAsync(CreateFile file, long personId)
    {
        return Db.GetTable<Files>().InsertWithInt64IdentityAsync(() => new Files
        {
            Data = Array.Empty<byte>(),
            Description = file.Description,
            Name = file.Name,
            Created = DateTime.UtcNow,
            DataType = file.DataType,
            PersonId = personId,
            Start = file.Start,
            Stop = file.Stop,
            Type = (int)file.Type,
            Valid = false,
        });
    }

    public async Task DeleteAsync(long id, long personId)
    {
        var result = await Db.GetTable<Files>()
            .DeleteAsync(x => x.Id == id && x.PersonId == personId);

        if (result == 0)
        {
            throw new InvalidDataException();
        }
    }

    public async Task<Paginated<Helse.Models.Files.File>> GetAsync(long personId, Pagination pagination)
    {
        var query = Db.GetTable<Files>()
            .Where(x => x.PersonId == personId);

        var count = await query.CountAsync();

        var result = await query
        .Skip(pagination.Page * pagination.PageSize)
        .Take(pagination.PageSize)
        .Select(x => new Helse.Models.Files.File
        {
            Description = x.Description,
            Name = x.Name,
            Created = x.Created,
            Id = x.Id,
            Start = x.Start,
            Stop = x.Stop,
            Type = (FileType)x.Type
        })
        .ToArrayAsync();

        return new()
        {
            Count = count,
            Items = result,
        };
    }

    public Task<Helse.Models.Files.File> GetAsync(long id, long personId)
    {
        return Db.GetTable<Files>()
            .Where(x => x.Id == id && x.PersonId == personId)
            .Select(x => new Helse.Models.Files.File
            {
                Description = x.Description,
                Name = x.Name,
                Created = x.Created,
                Id = x.Id,
                Start = x.Start,
                Stop = x.Stop,
                Type = (FileType)x.Type
            })
            .FirstAsync();
    }

    public Task<FileData> GetDataAsync(long id, long personId)
    {
        return Db.GetTable<Files>()
            .Where(x => x.Id == id && x.PersonId == personId && x.Valid)
            .Select(x => new FileData(x.DataType, x.Data))
            .FirstAsync();
    }

    public Task<Helse.Models.Files.File[]> GetFilesByEventAsync(long eventId, long personId)
    {
        return Db.GetTable<EventFiles>()
            .Where(x => x.EventId == eventId && x.File.PersonId == personId && x.File.Valid)
            .Select(x => new Helse.Models.Files.File
            {
                Description = x.File.Description,
                Name = x.File.Name,
                Created = x.Created,
                Id = x.File.Id,
                Start = x.File.Start,
                Stop = x.File.Stop,
                Type = (FileType)x.File.Type
            })
            .ToArrayAsync();
    }

    public Task<Helse.Models.Files.File[]> GetFilesByMetricAsync(long metricId, long personId)
    {
        return Db.GetTable<MetricFiles>()
            .Where(x => x.MetricId == metricId && x.File.PersonId == personId && x.File.Valid)
            .Select(x => new Helse.Models.Files.File
            {
                Description = x.File.Description,
                Name = x.File.Name,
                Created = x.Created,
                Id = x.File.Id,
                Start = x.File.Start,
                Stop = x.File.Stop,
                Type = (FileType)x.File.Type
            })
            .ToArrayAsync();
    }

    public Task LinkEventAsync(long eventId, long fileId, long personId)
    {
        return Db.GetTable<EventFiles>().InsertAsync(() => new EventFiles()
        {
            FileId = fileId,
            EventId = eventId,
            Created = DateTime.UtcNow,
        });
    }

    public Task LinkMetricAsync(long metricId, long fileId, long personId)
    {
        return Db.GetTable<MetricFiles>().InsertAsync(() => new MetricFiles()
        {
            FileId = fileId,
            MetricId = metricId,
            Created = DateTime.UtcNow,
        });
    }

    public Task SaveDataAsync(long id, long personId, byte[] data)
    {
        return Db.GetTable<Files>()
            .Where(x => x.Id == id && x.PersonId == personId)
            .Set(x => x.Data, data)
            .Set(x => x.Valid, true)
            .UpdateAsync();
    }

    public async Task UnlinkEventAsync(long eventId, long fileId, long personId)
    {
        var result = await Db.GetTable<EventFiles>()
        .DeleteAsync(x => x.EventId == eventId && x.FileId == fileId && x.File.PersonId == personId);

        if (result == 0)
        {
            throw new InvalidDataException();
        }
    }

    public async Task UnlinkMetricAsync(long metricId, long fileId, long personId)
    {
        var result = await Db.GetTable<MetricFiles>()
        .DeleteAsync(x => x.MetricId == metricId && x.FileId == fileId && x.File.PersonId == personId);

        if (result == 0)
        {
            throw new InvalidDataException();
        }
    }

    public async Task UpdateAsync(UpdateFile file, long personId)
    {
        var result = await Db.GetTable<Files>()
        .Where(x => x.Id == file.Id && x.PersonId == personId)
        .Set(x => x.Name, file.Name)
        .Set(x => x.Description, file.Description)
        .Set(x => x.DataType, file.DataType)
        .Set(x => x.Start, file.Start)
        .Set(x => x.Stop, file.Stop)
        .UpdateAsync();

        if (result == 0)
        {
            throw new InvalidDataException();
        }
    }
}
