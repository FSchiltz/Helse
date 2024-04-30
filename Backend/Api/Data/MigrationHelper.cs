using System.Reflection;
using DbUp;

namespace Api.Data;

public static class MigrationHelper
{
    public static void Init(string connection, bool inMemory, ILogger logger)
    {
        if (inMemory)
        {
            return;
        }

        EnsureDatabase.For.PostgresqlDatabase(connection);

        var result = DeployChanges.To.PostgresqlDatabase(connection)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .LogToAutodetectedLog()
            .Build()
            .PerformUpgrade();

        if (result.Successful)
        {
            logger.LogInformation("Migration Db");
        }
        else
        {
            throw new Exception("Migration error");
        }
    }
}