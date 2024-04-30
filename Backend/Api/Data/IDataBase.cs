using LinqToDB.Data;

namespace Api.Data;

public interface IContext {
    Task<DataConnectionTransaction> BeginTransactionAsync();
}
