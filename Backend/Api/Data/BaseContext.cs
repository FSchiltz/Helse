using LinqToDB.Data;

namespace Api.Data;

public abstract class BaseContext : IContext
{
    private readonly DataConnection db;

    protected BaseContext(DataConnection db, SlowQueryLogInterceptor interceptor)
    {
        this.db = db;
        db.AddInterceptor(interceptor);
    }

    protected DataConnection Db => db;

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public async Task<ITransaction> BeginTransactionAsync()
    {
        var fromDbTransaction = await Db.BeginTransactionAsync();
        return new Transaction(fromDbTransaction);
    }
}
