using Helse.Api.Data;

namespace Helse.Api.Logic.Import;

internal abstract class FileImporter(Stream file, IEventContext eventDb,IMetricContext metricDb, long user, long patient) 
: Importer(eventDb, metricDb, user, patient), IDisposable
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
