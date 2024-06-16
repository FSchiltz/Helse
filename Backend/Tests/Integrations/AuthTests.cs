using Api.Logic.Auth;
using Api.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

namespace Tests.Integrations;

public class AuthTests(WebApplicationFactory<Program> factory) : IntegrationTest(factory)
{
    const string personUrl = "/api/person";
    const string statusUrl = "/api/status";
    const string authUrl = "/api/auth";

    [Theory]
    [InlineData("/api/admin/settings/oauth")]
    [InlineData("/api/admin/settings/proxy")]
    [InlineData(personUrl)]
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

    [Theory]
    [InlineData(statusUrl)]
    public async Task Get_Anonymous(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Status()
    {
        var response = await _client.GetFromJsonAsync<Status>(statusUrl);

        Assert.NotNull(response);
        Assert.False(response.Init);
    }

    [Fact]
    public async Task FirstConnection()
    {
        // create the first user (shoudl allow)
        var admin = new PersonCreation
        {
            Password = "password",
            UserName = "admin",
        };
        var response = await _client.PostAsJsonAsync<PersonCreation>(personUrl, admin);
        Assert.NotNull(response);
        Assert.True(response.IsSuccessStatusCode);

        // get the status
        var status = await _client.GetFromJsonAsync<Status>(statusUrl);
        Assert.NotNull(status);
        Assert.True(status.Init);

        // try to create a new person witouth the right
        var wrongPerson = await _client.PostAsJsonAsync<PersonCreation>(personUrl, admin);
        Assert.NotNull(wrongPerson);
        Assert.False(wrongPerson.IsSuccessStatusCode);

        // Connect 
        var auth = await _client.PostAsJsonAsync(authUrl, new Connection(admin.UserName, admin.Password, null));
        Assert.NotNull(auth);
        
        var token = JsonSerializer.Deserialize<TokenResponse>(await auth.Content.ReadAsStringAsync());
        Assert.NotNull(token);
        Assert.NotNull(token.AccessToken);

        // try to create a new person with the right
        _client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token.AccessToken);
        var correct = await _client.PostAsJsonAsync<PersonCreation>(personUrl, new PersonCreation
        {
            UserName = "user",
            Password = "password",
            Name = "test",
        });
        Assert.NotNull(correct);
        Assert.True(correct.IsSuccessStatusCode);
    }
}