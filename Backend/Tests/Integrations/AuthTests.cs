using Helse.Api.Logic;
using Helse.Models;
using Helse.Models.Admin;
using Helse.Models.Persons;
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

namespace Tests.Integrations;

[Collection("Database collection")]
public class AuthTests(WebApplicationFactory<Program> factory, DatabaseFixture fixture) : IntegrationTest(factory, fixture)
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
        var client = await ClientAsync();
        var response = await client.GetAsync(url, TestContext.Current.CancellationToken);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/patients/agenda")]
    [InlineData("/api/patients/share")]
    [InlineData("/api/person/caregiver")]
    public async Task Get_NoPassword_2(string url)
    {
        var client = await ClientAsync();
        var response = await client.GetAsync(url, TestContext.Current.CancellationToken);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory(Skip = "Not Working")]
    [InlineData(statusUrl)]
    public async Task Get_Anonymous(string url)
    {
        var client = await ClientAsync();
        var response = await client.GetAsync(url, TestContext.Current.CancellationToken);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact(Skip = "Not Working")]
    public async Task Status()
    {
        var client = await ClientAsync();
        var response = await client.GetFromJsonAsync<Status>(statusUrl, cancellationToken: TestContext.Current.CancellationToken);

        Assert.NotNull(response);
        Assert.False(response.Init);
    }

    [Fact(Skip = "Not Working")]
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


        var client = await ClientAsync();
        var response = await client.PostAsJsonAsync<PersonCreation>(personUrl, admin, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(response);
        Assert.True(response.IsSuccessStatusCode);

        // get the status
        var status = await client.GetFromJsonAsync<Status>(statusUrl, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(status);
        Assert.True(status.Init);

        // try to create a new person witouth the right
        var wrongPerson = await client.PostAsJsonAsync<PersonCreation>(personUrl, admin, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(wrongPerson);
        Assert.False(wrongPerson.IsSuccessStatusCode);

        // Connect 
        var auth = await client.PostAsJsonAsync(authUrl, new Connection(admin.UserName, admin.Password, null, null), cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(auth);

        var token = JsonSerializer.Deserialize<ConnectionResponse>(await auth.Content.ReadAsStringAsync(TestContext.Current.CancellationToken));
        Assert.NotNull(token);
        Assert.NotNull(token.Roles);

        // try to create a new person with the right
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token.AccessToken);
        var correct = await client.PostAsJsonAsync<PersonCreation>(personUrl, new PersonCreation
        {
            UserName = "user",
            Password = "password",
            Name = "test",
        }, cancellationToken: TestContext.Current.CancellationToken);
        Assert.NotNull(correct);
        Assert.True(correct.IsSuccessStatusCode);
    }
}