using Microsoft.AspNetCore.Mvc.Testing;
using System.Net.Http.Json;

namespace Tests.Integrations;

[Collection("Database collection")]
public class EventType(WebApplicationFactory<Program> factory, DatabaseFixture fixture) : IntegrationTest(factory, fixture)
{
    const string groupsUrl = "/api/events/type";

    [Fact]
    public async Task CreateType()
    {
        // create the first user (should allow)
        var client = await ClientAsync();
        await ConnectAsync(client);

        var response = await client.PostAsJsonAsync(groupsUrl, new Helse.Models.Events.CreateEventType
        {
            Name = "test",
            Description = "test description",
            GroupId = 1,
        }, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(response);
        var text = await response.Content.ReadAsStringAsync(TestContext.Current.CancellationToken);
        Assert.True(response.IsSuccessStatusCode);
    }
}