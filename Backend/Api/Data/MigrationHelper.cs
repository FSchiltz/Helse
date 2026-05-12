using System.Reflection;
using DbUp;

namespace Api.Data;

public record MigrationSettings(string ConnectionString);

public class MigrationHelper(MigrationSettings settings, ILogger<MigrationHelper> logger) : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        EnsureDatabase.For.PostgresqlDatabase(settings.ConnectionString);

        var result = DeployChanges.To.PostgresqlDatabase(settings.ConnectionString)
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
            throw new Exception("Migration error" + result.Error);
        }
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}