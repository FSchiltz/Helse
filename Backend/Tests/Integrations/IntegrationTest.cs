using Api.Data;
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
         
    }
}
