using LinqToDB.Data;

namespace Helse.Api.Data;

internal abstract class BaseContext : IContext
{
    protected BaseContext(DataConnection db, SlowQueryLogInterceptor interceptor)
    {
        Db = db;
        db.AddInterceptor(interceptor);
    }

    protected DataConnection Db { get; }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public async Task<ITransaction> BeginTransactionAsync()
    {
        var fromDbTransaction = await Db.BeginTransactionAsync();
        return new Transaction(fromDbTransaction);
    }
}
