namespace Api.Data;

public interface ITransaction : IAsyncDisposable
{
    Task CommitAsync();

    Task RollbackAsync();
}
