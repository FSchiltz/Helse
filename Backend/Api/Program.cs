using System.Text;
using Api;
using Api.Data;
using Api.Helpers.Auth;
using LinqToDB;
using LinqToDB.AspNet;
using LinqToDB.AspNet.Logging;
using LinqToDB.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddOpenApi("helseapi");

//services cors
builder.Services.AddCors(p => p.AddPolicy("corsapp", builder => builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader()));

var connection = builder.Configuration.GetConnectionString("Default") ?? throw new InvalidOperationException("Database configuration missing");
builder.Services.AddLinqToDBContext<DataConnection>((provider, options)
            => options
                .UsePostgreSQL(connection, LinqToDB.DataProvider.PostgreSQL.PostgreSQLVersion.v15, (x) => new()
                {
                    IdentifierQuoteMode = LinqToDB.DataProvider.PostgreSQL.PostgreSQLIdentifierQuoteMode.None
                })
                //default logging will log everything using the ILoggerFactory configured in the provider
                .UseDefaultLogging(provider));

var issuer = builder.Configuration["Jwt:Issuer"] ?? throw new InvalidOperationException("Jwt issuer missing");
var audience = builder.Configuration["Jwt:Audience"] ?? throw new InvalidOperationException("Jwt audience missing");
var keyConfig = builder.Configuration["Jwt:Key"] ?? throw new InvalidOperationException("Jwt key missing");

var keyText = Encoding.UTF8.GetBytes(keyConfig).Take(512).ToArray();
var generatedKey = new byte[512];

var startAt = generatedKey.Length - keyText.Length;
Array.Copy(keyText, 0, generatedKey, startAt, keyText.Length);

var key = new SymmetricSecurityKey(generatedKey);

builder.Services.AddSingleton(new TokenService(issuer, audience, key));
builder.Services.AddTransient<IUserContext, UserContext>();
builder.Services.AddTransient<ISettingsContext, SettingsContext>();
builder.Services.AddTransient<IHealthContext, HealthContext>();

builder.Services.AddAuthentication(options =>
  {
      options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
      options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
      options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
  })
  .AddJwtBearer(o =>
  {
      o.TokenValidationParameters = new TokenValidationParameters
      {
          ValidIssuer = issuer,
          ValidAudience = audience,
          IssuerSigningKey = key,
          ValidateIssuer = true,
          ValidateAudience = true,
          ValidateLifetime = true,
          ValidateIssuerSigningKey = false,
          ClockSkew = TimeSpan.Zero
      };
  });

builder.Services.AddAuthorizationBuilder()
    .SetDefaultPolicy(new AuthorizationPolicyBuilder()
            .RequireClaim("token", ["access"])
            .Build());

var app = builder.Build();

app.MapOpenApi("/openapi/{documentName}.json");
app.UseSwaggerUI(options => options.SwaggerEndpoint("/openapi/helseapi.json", "api"));

app.UseCors("corsapp");
app.UseAuthentication();
app.UseAuthorization();

app.UseDefaultFiles();
app.UseStaticFiles();

var api = app.MapGroup("/api");
api.MapEnpoints();

MigrationHelper.Init(connection, app.Logger);

app.Run();

public partial class Program { }