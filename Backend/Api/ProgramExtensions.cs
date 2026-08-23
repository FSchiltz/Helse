using Helse.Api.Configuration;
using LinqToDB.Data;
using LinqToDB.Extensions.DependencyInjection;
using LinqToDB.Mapping;
using Microsoft.Extensions.Options;
using LinqToDB;
using LinqToDB.Extensions.Logging;

namespace Helse.Api;

public static class ProgramExtensions
{
    public static void AddDatabase(this WebApplicationBuilder builder)
    {
        builder.Services.AddLinqToDBContext<DataConnection>((provider, options) =>
        {
            var logging = provider.GetRequiredService<ILoggerFactory>().CreateLogger("Database");
            var mapper = new MappingSchema();
            mapper.SetConverter<DateTime, DateTime>(x => DateTime.SpecifyKind(x, DateTimeKind.Utc));
            var config = provider.GetRequiredService<IOptions<DatabaseConfig>>();
            if (config.Value.Sqlite is not null)
            {
                // Using sqllite
                return options.UseSQLite(config.Value.Sqlite).UseDefaultLogging(provider).UseMappingSchema(mapper);
            }
            else if (config.Value.Postgres is not null)
            {
                return options
                        .UsePostgreSQL(config.Value.Postgres, LinqToDB.DataProvider.PostgreSQL.PostgreSQLVersion.v15, (x) => new()
                        {
                            IdentifierQuoteMode = LinqToDB.DataProvider.PostgreSQL.PostgreSQLIdentifierQuoteMode.None
                        })

                        //default logging will log everything using the ILoggerFactory configured in the provider
                        .UseDefaultLogging(provider)
                        .UseMappingSchema(mapper);
            }
            else
            {
                // Todo fallback to a sqlite database
                throw new InvalidOperationException("Missing database config");
            }
        });

    }
}