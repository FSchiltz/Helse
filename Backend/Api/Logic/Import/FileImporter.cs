using Api.Data;
using Api.Data.Models;
using Api.Jobs;
using Api.Models.Events;
using Api.Models.Metrics;

namespace Api.Logic.Import;

public abstract class FileImporter(Stream file, IHealthContext db, User user) : Importer(db, user), IDisposable
{
    private bool disposedValue;

    public Stream File { get; } = file;

    protected virtual void Dispose(bool disposing)
    {
        if (!disposedValue)
        {
            if (disposing)
            {
                File.Dispose();
            }

            disposedValue = true;
        }
    }

    // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
    // ~FileImporter()
    // {
    //     // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
    //     Dispose(disposing: false);
    // }

    public void Dispose()
    {
        // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
        Dispose(disposing: true);
        GC.SuppressFinalize(this);
    }
}

public enum JobStatus
{
    NotStarted,
    InProgress,
    Done,
    InError,
}

public abstract class Importer(IHealthContext db, Data.Models.User user)
{
    public Data.Models.User User { get; } = user;

    public abstract Task Import(IImportQueue queue, Guid id);

    protected async Task ImportEvent(CreateEvent e)
    {
        if (e.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the event exists
        var fromDb = await db.ExistsEvent(User.PersonId, e.Tag);

        if (!fromDb)
        {
            await db.Insert(e, User.PersonId, User.Id);
        }

        await transaction.CommitAsync();
    }

    protected async Task ImportMetric(CreateMetric metric)
    {
        if (metric.Tag is null)
            return;

        await using var transaction = await db.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await db.ExistsMetric(User.PersonId, metric.Tag, metric.Source);

        if (!fromDb)
        {
            await db.Insert(metric, User.PersonId, User.Id);
        }

        await transaction.CommitAsync();
    }
}