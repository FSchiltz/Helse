using Api.Data;
using LinqToDB;
using LinqToDB.Data;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Tests.Integrations;

public abstract class IntegrationTest(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    private const string connection = "Data Source=:memory:?cache=shared";
    protected readonly HttpClient _client = factory
                 .WithWebHostBuilder(builder =>
                    builder
                        .ConfigureAppConfiguration((_, config) => config.AddInMemoryCollection([new("ConnectionStrings:Default", connection)]))
                        .ConfigureTestServices(services =>
                        {
                            var db = services.Single(d => d.ServiceType == typeof(DataConnection));
                            services.Remove(db);
                            // Create open SqliteConnection so EF won't automatically close it.
                            services.AddSingleton(new DataConnection("SQLite.MS", (_) => new DataOptions().UseSQLite(connection)));

                            var migration = services.Single(d => d.ImplementationType == typeof(MigrationHelper));
                            services.Remove(migration);
                            services.AddHostedService<TestMigrationHelper>(x => new TestMigrationHelper(new MigrationSettings(connection)));
                        }))
                 .CreateClient();
}
