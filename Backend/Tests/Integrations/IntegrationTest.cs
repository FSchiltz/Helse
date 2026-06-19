using LinqToDB;
using LinqToDB.Data;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Tests.Integrations;

public abstract class IntegrationTest(WebApplicationFactory<Program> factory, DatabaseFixture fixture) : IClassFixture<WebApplicationFactory<Program>>
{
    public async Task<HttpClient> ClientAsync()
    {
        var connection = await fixture.GetTempDB();
        return factory
                 .WithWebHostBuilder(builder =>
                    builder
                        .ConfigureAppConfiguration((_, config) => config.AddInMemoryCollection([new("ConnectionStrings:Default", connection)]))
                        .ConfigureTestServices(services =>
                        {
                            var db = services.Single(d => d.ServiceType == typeof(DataConnection));
                            services.Remove(db);
                            // Create open SqliteConnection so EF won't automatically close it.
                            services.AddSingleton(new DataConnection((_) => new DataOptions().UsePostgreSQL(connection)));
                        }))
                 .CreateClient();
    }
}
