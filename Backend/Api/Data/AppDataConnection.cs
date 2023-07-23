using System.Reflection;
using DbUp;
using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public class AppDataConnection : DataConnection
{
    public AppDataConnection(DataOptions<AppDataConnection> options)
        : base(options.Options)
    {

    }

    public static void Init(string connection, ILogger logger)
    {
        EnsureDatabase.For.PostgresqlDatabase(connection);

        var upgrader =
             DeployChanges.To
         .PostgresqlDatabase(connection)
         .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
         .LogToAutodetectedLog()
         .Build();

        var result = upgrader.PerformUpgrade();

        if (result.Successful)
        {
            logger.LogInformation("Migration Db");
        }
        else
        {
            logger.LogError("Migration error : {error}", result.Error);
        }

    }
}