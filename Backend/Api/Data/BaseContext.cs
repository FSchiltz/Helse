using LinqToDB.Data;

namespace Api.Data;

public abstract class BaseContext(DataConnection db) : IContext
{
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
