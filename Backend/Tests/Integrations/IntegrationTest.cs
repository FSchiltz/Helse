using Microsoft.AspNetCore.Mvc.Testing;
using LinqToDB;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using NSubstitute;

namespace Tests.Integrations;

public abstract class IntegrationTest: IClassFixture<WebApplicationFactory<Program>> {

    protected readonly HttpClient _client;
    protected IDataContext mockDB = Substitute.For<IDataContext>();

    public IntegrationTest(WebApplicationFactory<Program> factory)
    {
        _client = factory
                 .WithWebHostBuilder(builder =>
                    builder
                        .ConfigureAppConfiguration((_, config) => config.AddInMemoryCollection([new("InTest", "True")]))
                        .ConfigureTestServices(services => services.AddSingleton(mockDB)))
                 .CreateClient();
    }
}
