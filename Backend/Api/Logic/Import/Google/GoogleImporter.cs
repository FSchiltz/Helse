using Api.Data;
using Api.Jobs;

namespace Api.Logic.Import;

public class GoogleImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    public override Task Import(IImportQueue queue, Guid id)
    {
        throw new NotImplementedException();
    }
}
