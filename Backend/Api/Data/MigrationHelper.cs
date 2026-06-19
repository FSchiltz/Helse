using System.Reflection;
using DbUp;
using Microsoft.Extensions.Options;

namespace Helse.Api.Data;

internal class MigrationSettings
{
    public static string Name => "ConnectionStrings";

    public required string Default { get; set; }
}

internal class MigrationHelper(IOptions<MigrationSettings> settings, ILogger<MigrationHelper> logger) : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        EnsureDatabase.For.PostgresqlDatabase(settings.Value.Default);

        var result = DeployChanges.To.PostgresqlDatabase(settings.Value.Default)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .LogTo(logger)
            .WithTransactionPerScript()
            .Build()
            .PerformUpgrade();

        if (result.Successful)
        {
            logger.LogInformation("Migration Db");
        }
        else
        {
            throw new InvalidOperationException("Migration error" + result.Error);
        }
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}