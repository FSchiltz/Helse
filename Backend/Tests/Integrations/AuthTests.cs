using Api.Data;
using Microsoft.AspNetCore.Mvc.Testing;
using LinqToDB.AspNet;
using System.Net;

namespace Tests.Integrations;

public class AuthTests(WebApplicationFactory<Program> factory) : IntegrationTest(factory)
{
    [Theory]
    [InlineData("/admin/oauth")]
    [InlineData("/admin/proxy")]
    [InlineData("/person")]
    [InlineData("/events")]
    [InlineData("/import/types")]
    public async Task Get_NoPassword(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }
}