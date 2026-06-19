namespace Helse.Api.Data;

internal interface ITransaction : IAsyncDisposable
{
    Task CommitAsync();

    Task RollbackAsync();
}
