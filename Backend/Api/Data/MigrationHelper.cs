using System.Reflection;
using DbUp;
using DbUp.Engine;
using Helse.Api.Configuration;
using Microsoft.Extensions.Options;

namespace Helse.Api.Data;

internal class MigrationHelper(IOptions<DatabaseConfig> settings, ILogger<MigrationHelper> logger) : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        DatabaseUpgradeResult result;
        if (settings.Value.Postgres is not null)
        {

            EnsureDatabase.For.PostgresqlDatabase(settings.Value.Postgres);

            result = DeployChanges.To.PostgresqlDatabase(settings.Value.Postgres)
           .WithScriptNameComparer(new AssemblyInvariantComparer())
           .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
           .LogTo(logger)
           .WithTransactionPerScript()
           .Build()
           .PerformUpgrade();
        }
        else if (settings.Value.Sqlite is not null)
        {
            EnsureDatabase.For.SqlDatabase(settings.Value.Sqlite);

            result = DeployChanges.To.SqliteDatabase(settings.Value.Sqlite)
           .WithScriptNameComparer(new AssemblyInvariantComparer())
           .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
           .LogTo(logger)
           .WithTransactionPerScript()
           .Build()
           .PerformUpgrade();
        }
        else { throw new InvalidDataException("Invalid database"); }

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

/// <summary>
/// Allows renaming the assembly containing the scripts files
/// </summary>
internal class AssemblyInvariantComparer : IComparer<string>
{
    public int Compare(string? x, string? y)
    {
        if (x is null || y is null)
        {
            return -1;
        }

        var xNames = x.Split('.');
        var yNames = y.Split('.');
        if (xNames.Length < 2 || yNames.Length < 2)
        {
            return -1;
        }

        var xName = $"{xNames[^2]}.{xNames[^1]}";
        var yName = $"{yNames[^2]}.{yNames[^1]}";

        return xName.CompareTo(yName, StringComparison.OrdinalIgnoreCase);
    }
}