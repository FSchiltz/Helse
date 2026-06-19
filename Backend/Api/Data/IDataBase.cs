namespace Helse.Api.Data;

/// <summary>
/// Base interface for the database contexts.
/// </summary>
internal interface IContext {
    Task<ITransaction> BeginTransactionAsync();
}
