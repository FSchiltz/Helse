using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using NSubstitute;
using Api.Data;

namespace Tests.Integrations;

public abstract class IntegrationTest : IClassFixture<WebApplicationFactory<Program>>
{

    protected readonly HttpClient _client;

    public IntegrationTest(WebApplicationFactory<Program> factory)
    {
        var db = new 
        _client = factory
                 .WithWebHostBuilder(builder =>
                    builder
                        .ConfigureAppConfiguration((_, config) => config.AddInMemoryCollection([new("InTest", "True")]))
                        .ConfigureTestServices(services => services.AddSingleton(new UserContext(db))))
                 .CreateClient();
    }
}
