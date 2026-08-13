using Helse.Api.Data;

namespace Helse.Api.Logic.Import;

internal abstract class FileImporter(Stream file, IEventContext eventDb,IMetricContext metricDb, long user, long patient) 
: Importer(eventDb, metricDb, user, patient)
{
    private bool disposedValue;

    public Stream File { get; } = file;

    protected override void Dispose(bool disposing)
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
}
