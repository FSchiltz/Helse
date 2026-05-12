namespace Api.Data;

/// <summary>
/// Base interface for the database contexts.
/// </summary>
public interface IContext {
    Task<ITransaction> BeginTransactionAsync();
}
