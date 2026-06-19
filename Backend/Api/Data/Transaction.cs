using LinqToDB.Data;

namespace Helse.Api.Data;

public class Transaction(DataConnectionTransaction transaction) : ITransaction
{
    public Task CommitAsync() => transaction.CommitAsync();

    public Task RollbackAsync() => transaction.RollbackAsync();

    public ValueTask DisposeAsync() => transaction.DisposeAsync();
}
