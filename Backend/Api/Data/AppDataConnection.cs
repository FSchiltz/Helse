using LinqToDB;
using LinqToDB.Data;

namespace Api.Data;

public class AppDataConnection: DataConnection
{    
    public AppDataConnection(DataOptions<AppDataConnection> options)
        :base(options.Options)
    {

    }    
}