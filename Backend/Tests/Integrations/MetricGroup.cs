using Microsoft.AspNetCore.Mvc.Testing;
using System.Net.Http.Json;

namespace Tests.Integrations;

[Collection("Database collection")]
public class MetricGroup(WebApplicationFactory<Program> factory, DatabaseFixture fixture) : IntegrationTest(factory, fixture)
{
    const string groupsUrl = "/api/metrics/groups";

    [Fact]
    public async Task CreateGroup()
    {
        // create the first user (should allow)
        var client = await ClientAsync();
        await ConnectAsync(client);

        var response = await client.PostAsJsonAsync(groupsUrl, new Helse.Models.Metrics.CreateGroup
        {
            Name = "test",
            Description = "test description",
            ShowOnDashboard = true,
            ShowTitle = true,
        }, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(response);
        var text = await response.Content.ReadAsStringAsync(TestContext.Current.CancellationToken);
        Assert.True(response.IsSuccessStatusCode);
    }
}