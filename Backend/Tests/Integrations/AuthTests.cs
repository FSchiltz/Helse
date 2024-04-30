using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;

namespace Tests.Integrations;

public class AuthTests(WebApplicationFactory<Program> factory) : IntegrationTest(factory)
{
    [Theory]
    [InlineData("/api/admin/settings/oauth")]
    [InlineData("/api/admin/settings/proxy")]
    [InlineData("/api/person")]
    [InlineData("/api/events")]
    [InlineData("/api/events/type")]
    [InlineData("/api/metrics/")]
    [InlineData("/api/metrics/type")]
    [InlineData("/api/treatment/")]
    [InlineData("/api/import/types")]
    public async Task Get_NoPassword(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }
}