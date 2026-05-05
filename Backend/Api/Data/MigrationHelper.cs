using System.Reflection;
using DbUp;

namespace Api.Data;

public static class MigrationHelper
{
    public static void Init(string connection,ILogger logger)
    {
        EnsureDatabase.For.PostgresqlDatabase(connection);

        var result = DeployChanges.To.PostgresqlDatabase(connection)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .LogTo(logger)
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