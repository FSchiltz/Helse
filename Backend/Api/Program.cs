using System.Diagnostics;
using System.Text.Json.Serialization;
using Api;
using Api.Data;
using Api.Helpers.Auth;
using Api.Jobs;
using Api.Logic.Auth;
using LinqToDB;
using LinqToDB.AspNet;
using LinqToDB.AspNet.Logging;
using LinqToDB.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(kestrel => kestrel.Limits.MaxRequestBodySize = 100 * 1000 * 1000);

// Add services to the container.
builder.Services.ConfigureHttpJsonOptions(options => options.SerializerOptions.Converters.Add(new JsonStringEnumConverter()));
builder.Services.AddOpenApi("helseapi");

//services cors
builder.Services.AddCors(p => p.AddPolicy("corsapp", builder => builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader()));
var connection = builder.Configuration.GetConnectionString("Default") ?? throw new InvalidOperationException("Database configuration missing");

builder.Services.AddLinqToDBContext<DataConnection>((provider, options) =>
            {
                return options
                           .UsePostgreSQL(connection, LinqToDB.DataProvider.PostgreSQL.PostgreSQLVersion.v15, (x) => new()
                           {
                               IdentifierQuoteMode = LinqToDB.DataProvider.PostgreSQL.PostgreSQLIdentifierQuoteMode.None
                           })
                           //default logging will log everything using the ILoggerFactory configured in the provider
                           .UseDefaultLogging(provider);
            });

var config = builder.Configuration.GetRequiredSection("Jwt");
var issuer = config["Issuer"] ?? throw new InvalidOperationException("Jwt issuer missing");
var audience = config["Audience"] ?? throw new InvalidOperationException("Jwt audience missing");
var keyConfig = config["Key"] ?? throw new InvalidOperationException("Jwt key missing");

SymmetricSecurityKey key = AuthLogic.GenerateKey(keyConfig);

builder.Services.AddSingleton((_) => new TokenConfig(issuer, audience, key));


builder.Services.AddSingleton<TokenService>()
    .AddTransient<IUserContext, UserContext>()
    .AddTransient<ISettingsContext, SettingsContext>()
    .AddTransient<IHealthContext, HealthContext>()
    .AddTransient<IStatsContext, StatsContext>();

builder.Services.AddAuthentication(options =>
  {
      options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
      options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
      options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
  })
  .AddJwtBearer((o) =>
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

builder.Services.AddSingleton(new MigrationSettings(connection));
builder.Services.AddHostedService<MigrationHelper>();
builder.Services.AddHostedService<EventNotificationService>();
builder.Services.AddHostedService<ImporterService>()
    .AddSingleton<IImportQueue, ImportQueue>();

builder.Services.AddHttpClient();

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

app.Run();

public partial class Program { }