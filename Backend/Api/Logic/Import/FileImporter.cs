using Api.Data;
using Api.Data.Models;

namespace Api.Logic.Import;

public abstract class FileImporter(Stream file, IHealthContext db, long user, long patient) : Importer(db, user, patient), IDisposable
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
