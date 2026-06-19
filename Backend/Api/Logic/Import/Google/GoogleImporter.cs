using Helse.Api.Data;
using Helse.Api.Jobs;
using Helse.Models.Imports;

namespace Helse.Api.Logic.Import.Google;

internal class GoogleImporter(Stream file, IEventContext eventDb,IMetricContext metricDb, long user, long patient) : FileImporter(file, eventDb, metricDb, user, patient)
{
    public override Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        throw new NotImplementedException();
    }
}
