using System.Reflection;
using Api.Data;
using DbUp;
using Microsoft.Extensions.Hosting;

namespace Tests.Integrations;

public class TestMigrationHelper(MigrationSettings settings) : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        var result = DeployChanges.To.PostgresqlDatabase(settings.ConnectionString)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .Build()
            .PerformUpgrade();

        if (!result.Successful)
        {
            throw result.Error;
        }
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
