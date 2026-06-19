using System.Data;
using System.Data.Common;
using System.Diagnostics;
using LinqToDB.Common;
using LinqToDB.Interceptors;

namespace Helse.Api.Data;

internal class SlowQueryLogInterceptor(ILogger<SlowQueryLogInterceptor> logger) : ICommandInterceptor
{
    private Stopwatch? stopwatch;

    public void AfterExecuteReader(CommandEventData eventData, DbCommand command, CommandBehavior commandBehavior, DbDataReader dataReader)
    {
        stopwatch?.Stop();
        var time = stopwatch?.ElapsedMilliseconds ?? 0;
        if (time > 300)
        {
            logger.LogWarning("Slow query ran in {Time}ms: {Query}", time, command.CommandText);
        }
    }

    public void BeforeReaderDispose(CommandEventData eventData, DbCommand? command, DbDataReader dataReader)
    {
    }

    public Task BeforeReaderDisposeAsync(CommandEventData eventData, DbCommand? command, DbDataReader dataReader)
    {
        return Task.CompletedTask;
    }

    public DbCommand CommandInitialized(CommandEventData eventData, DbCommand command)
    {
        stopwatch = new();
        stopwatch.Start();
        return command;
    }

    public Option<int> ExecuteNonQuery(CommandEventData eventData, DbCommand command, Option<int> result)
    {
        return result;
    }

    public Task<Option<int>> ExecuteNonQueryAsync(CommandEventData eventData, DbCommand command, Option<int> result, CancellationToken cancellationToken)
    {
        return Task.FromResult(result);
    }

    public Option<DbDataReader> ExecuteReader(CommandEventData eventData, DbCommand command, CommandBehavior commandBehavior, Option<DbDataReader> result)
    {
        throw new NotImplementedException();
    }

    public Task<Option<DbDataReader>> ExecuteReaderAsync(CommandEventData eventData, DbCommand command, CommandBehavior commandBehavior, Option<DbDataReader> result, CancellationToken cancellationToken)
    {
        return Task.FromResult(result);
    }

    public Option<object?> ExecuteScalar(CommandEventData eventData, DbCommand command, Option<object?> result)
    {
        return result;
    }

    public Task<Option<object?>> ExecuteScalarAsync(CommandEventData eventData, DbCommand command, Option<object?> result, CancellationToken cancellationToken)
    {
        return Task.FromResult(result);
    }
}
