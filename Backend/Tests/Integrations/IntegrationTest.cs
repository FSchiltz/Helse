using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Helse.Models;
using Helse.Models.Persons;
using LinqToDB;
using LinqToDB.Data;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Tests.Integrations;

public abstract class IntegrationTest : IClassFixture<WebApplicationFactory<Program>>
{
    protected const string personUrl = "/api/person";
    protected const string statusUrl = "/api/status";
    protected const string authUrl = "/api/auth";
    private readonly WebApplicationFactory<Program> factory;
    private readonly DatabaseFixture fixture;

    protected readonly JsonSerializerOptions options;

    protected IntegrationTest(WebApplicationFactory<Program> factory, DatabaseFixture fixture)
    {
        this.factory = factory;
        this.fixture = fixture;
        options = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        };
        options.Converters.Add(new JsonStringEnumConverter());
    }

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
                            services.AddSingleton(new DataConnection((_) => new DataOptions().UsePostgreSQL(connection, LinqToDB.DataProvider.PostgreSQL.PostgreSQLVersion.v15, (x) => new()
                            {
                                IdentifierQuoteMode = LinqToDB.DataProvider.PostgreSQL.PostgreSQLIdentifierQuoteMode.None
                            })));
                        }))
                 .CreateClient();
    }

    public async Task<(PersonCreation User, string Token)> ConnectAsync(HttpClient client)
    {
        var admin = new PersonCreation
        {
            Types = [UserType.Admin, UserType.User],
            Password = "password",
            UserName = "admin",
            Name = "DisplayName",
        };
        await client.PostAsJsonAsync(personUrl, admin, cancellationToken: TestContext.Current.CancellationToken);

        var auth = await client.PostAsJsonAsync(authUrl, new Connection(admin.UserName, admin.Password, null, null), cancellationToken: TestContext.Current.CancellationToken);

        var authResponse = await auth.Content.ReadAsStringAsync(TestContext.Current.CancellationToken);
        var token = JsonSerializer.Deserialize<ConnectionResponse>(authResponse, options);
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token?.AccessToken);

        return (admin, token?.RefreshToken ?? throw new InvalidDataException());
    }
}
