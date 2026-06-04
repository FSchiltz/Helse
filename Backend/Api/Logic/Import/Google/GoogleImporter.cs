using Api.Data;
using Api.Jobs;
using Api.Models.Imports;

namespace Api.Logic.Import.Google;

public class GoogleImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    public override Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        throw new NotImplementedException();
    }
}
