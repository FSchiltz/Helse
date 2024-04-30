using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text.Json;
using Api.Data;
using Api.Models;

namespace Api.Helpers.Auth;

public static class OauthHelper
{
    private static readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true
    };

    private record Token(string User, string? Name);
    private class OauthToken
    {
        public string? Access_token { get; set; }
    }

    public static async Task<(bool logged, TokenInfo? fromDb)> ConnectOauth(IUserContext db, Oauth oauth, Connection user, ILogger log)
    {
        var token = await oauth.GetOauthTokenAsync(user);

        var fromDb = await db.TokenFromDb(token.User);

        var logged = false;
        if (fromDb is null)
        {
            if (oauth.AutoRegister)
            {
                log.LogInformation("User created for {header}", user.Redirect);
                // If auto register and not found, we create it
                await db.CreateUserAsync(new PersonCreation
                {
                    UserName = token.User,
                    Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                    Type = UserType.User,
                    Name = token.Name,
                }, 0);
                logged = true;
                fromDb = await db.TokenFromDb(token.User);
            }
        }
        else
        {
            logged = true;
        }

        return (logged, fromDb);
    }

    private static async Task<Token> GetOauthTokenAsync(this Oauth oauth, Connection user)
    {
        // get the jwt token from the oauth server
        using var client = new HttpClient();

        using var content = new FormUrlEncodedContent([
            new ("grant_type","authorization_code"),
            new ("code", user.Password),
            new ("redirect_uri", user.Redirect),
        ]);

        var authenticationString = $"{oauth.ClientId}:{oauth.ClientSecret}";
        var base64EncodedAuthenticationString = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(authenticationString));

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", base64EncodedAuthenticationString);
        var response = await client.PostAsync(oauth.Tokenurl, content);

        var contentString = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();
        return Parse(contentString);
    }

    private static Token Parse(string content)
    {
        var auth = JsonSerializer.Deserialize<OauthToken>(content, _options);

        var jwt = auth?.Access_token ?? throw new InvalidOperationException("Incorrect token");

        var token = new JwtSecurityTokenHandler().ReadJwtToken(jwt);

        var claim = token.Payload.Claims.First(x => x.Type == "preferred_username" || x.Type == JwtRegisteredClaimNames.UniqueName);
        var name = token.Payload.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Name || x.Type == JwtRegisteredClaimNames.FamilyName);
        return new Token(claim.Value, name?.Value ?? claim.Value);
    }
}
