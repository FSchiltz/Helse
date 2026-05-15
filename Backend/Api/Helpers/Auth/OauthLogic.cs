using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text.Json;
using Api.Data;
using Api.Data.Models;
using Api.Models;
using Api.Models.Persons;
using Api.Models.Settings.Admin;

namespace Api.Helpers.Auth;

public static class OauthHelper
{
    private static readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true
    };

    private record Token(string Issuer, string User, string IdToken, string AccessToken);

    private class UserInfo
    {
        public string? Name { get; set; }
        public string? Preferred_username { get; set; }
        public int Rat { get; set; }
        public string? Sub { get; set; }
        public int Updated_at { get; set; }
    }

    private class OauthToken
    {
        public string? Access_token { get; set; }

        public int Expires_in { get; set; }

        public string? Id_token { get; set; }

        public string? Scope { get; set; }

        public string? Token_type { get; set; }
    }

    public static async Task<(bool logged, TokenInfo? fromDb)> ConnectOauth(IUserContext db, Oauth oauth, Connection user, ILogger log)
    {
        var provider = oauth.Providers.First(p => p.ClientId == user.Issuer);
        var token = await provider.GetOauthTokenAsync(user);

        var fromDb = await db.TokenFromDb(token.User, provider.ClientId);

        var logged = false;
        if (fromDb is null)
        {
            if (provider.AutoRegister)
            {
                // get the claims from the claims endpoint.
                var claims = await GetClaimsAsync(provider, token.AccessToken);

                log.LogInformation("User created for {header}", user.Issuer);
                await using var transaction = await db.BeginTransactionAsync();
                // If auto register and not found, we create it
                var id = await db.CreateUserAsync(new PersonCreation
                {
                    UserName = claims.Preferred_username,
                    Password = RandomNumberGenerator.GetInt32(100000000, int.MaxValue).ToString(),
                    Types = [Api.Models.Persons.UserType.User],
                    Name = claims.Name,
                }, 0);

                await db.LinkOauth(new OauthUser
                {
                    Provider = provider.ClientId,
                    OauthSub = token.User,
                    UserId = id.User ?? throw new InvalidOperationException("User creation failed"),
                });

                await transaction.CommitAsync();

                logged = true;
                fromDb = await db.TokenFromDb(token.User, provider.ClientId);
            }
        }
        else
        {
            logged = true;
        }

        return (logged, fromDb);
    }

    private static async Task<UserInfo> GetClaimsAsync(OauthProvider oauth, string accessToken)
    {
        using var client = new HttpClient();

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        var response = await client.GetAsync(oauth.ClaimsUrl);

        var contentString = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();

        return JsonSerializer.Deserialize<UserInfo>(contentString, _options) ?? throw new InvalidOperationException("Incorrect claims");
    }

    private static async Task<Token> GetOauthTokenAsync(this OauthProvider oauth, Connection user)
    {
        // get the jwt token from the oauth server
        using var client = new HttpClient();

        using var content = new FormUrlEncodedContent([
            new ("grant_type","authorization_code"),
            new ("code", user.Password),
            new ("redirect_uri", user.Redirect),
        ]);

        var authenticationString = $"{oauth.ClientId}:{oauth.ClientSecret}";
        var base64EncodedAuthenticationString = Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(authenticationString));

        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", base64EncodedAuthenticationString);
        var response = await client.PostAsync(oauth.Tokenurl, content);

        var contentString = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();

        var auth = JsonSerializer.Deserialize<OauthToken>(contentString, _options);

        var access = auth?.Access_token ?? throw new InvalidOperationException("Incorrect token");
        var id = auth.Id_token ?? throw new InvalidOperationException("Incorrect token");

        var token = new JwtSecurityTokenHandler().ReadJwtToken(id);

        var claim = token.Payload.Claims.First(x => x.Type == JwtRegisteredClaimNames.Sub);
        var issuer = token.Issuer;

        return new Token(issuer, claim.Value, id, access);
    }
}
