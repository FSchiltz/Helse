using System.Reflection;
using DbUp;
using DbUp.Engine;
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
            .WithScriptNameComparer(new AssemblyInvariantComparer())
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