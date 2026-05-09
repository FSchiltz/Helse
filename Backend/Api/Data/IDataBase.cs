namespace Api.Data;

public interface IContext {
    Task<ITransaction> BeginTransactionAsync();
}
