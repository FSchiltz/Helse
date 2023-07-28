using Api.Data;

namespace Api.Logic.Import;

public abstract class FileImporter
{
    protected FileImporter(string file, AppDataConnection dataConnection, Data.Models.User user)
    {
        File = file;
        DataConnection = dataConnection;
        User = user;
    }

    public string File { get; }
    public AppDataConnection DataConnection { get; }
    public Data.Models.User User { get; }

    public abstract Task Import();
}