using Api.Data;
using Api.Data.Models;

namespace Api.Logic.Import;

public class GagdgetImporter : FileImporter
{
    public GagdgetImporter(string file, AppDataConnection dataConnection, User user) : base(file, dataConnection, user)
    {
    }

    public override Task Import()
    {
        using var reader = new StringReader(File);

        return Task.CompletedTask;
    }
}