using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;

namespace Tests.Integrations;

public abstract class IntegrationTest(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    protected readonly HttpClient _client = factory
                 .WithWebHostBuilder(builder =>
                    builder
                        .ConfigureAppConfiguration((_, config) => config.AddInMemoryCollection([new("InTest", "True"), new("ConnectionStrings:Default", ":memory:")]))
                        .ConfigureTestServices(services => { }))
                 .CreateClient();
}
