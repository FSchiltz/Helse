using LinqToDB.Data;

namespace Helse.Api.Data;

internal class FilesContext(DataConnection db, SlowQueryLogInterceptor interceptor) : BaseContext(db, interceptor), IFilesContext
{
    
}
