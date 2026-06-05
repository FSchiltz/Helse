using Api.Logic;
using Api.Models;
using Api.Models.Persons;
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
    [InlineData("/api/patients")]
    public async Task Get_NoPassword(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/patients/agenda")]
    [InlineData("/api/patients/share")]
    [InlineData("/api/person/caregiver")]
    public async Task Get_NoPassword_2(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory(Skip = "not working")]
    [InlineData(statusUrl)]
    public async Task Get_Anonymous(string url)
    {
        var response = await _client.GetAsync(url);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact(Skip = "not working")]
    public async Task Status()
    {
        var response = await _client.GetFromJsonAsync<Status>(statusUrl);

        Assert.NotNull(response);
        Assert.False(response.Init);
    }

    [Fact(Skip = "not working")]
    public async Task FirstConnection()
    {
        // create the first user (shoudl allow)
        var admin = new PersonCreation
        {
            Types = [UserType.Admin, UserType.User],
            Password = "password",
            UserName = "admin",
            Name = "DisplayName",
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
        var auth = await _client.PostAsJsonAsync(authUrl, new Connection(admin.UserName, admin.Password, null, null));
        Assert.NotNull(auth);

        var token = JsonSerializer.Deserialize<ConnectionResponse>(await auth.Content.ReadAsStringAsync());
        Assert.NotNull(token);
        Assert.NotNull(token.Roles);

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