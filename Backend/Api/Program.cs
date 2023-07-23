using System.Text;
using Api.Data;
using Api.Helpers;
using Api.Logic;
using LinqToDB;
using LinqToDB.AspNet;
using LinqToDB.AspNet.Logging;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connection = builder.Configuration.GetConnectionString("Default") ?? throw new InvalidOperationException("Database configuration missing");

builder.Services.AddLinqToDBContext<AppDataConnection>((provider, options)
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
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyConfig));

builder.Services.AddSingleton(new TokenService(issuer, audience, key));

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
      ValidateIssuerSigningKey = true
    };
  });

builder.Services.AddAuthorization();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
  app.UseSwagger();
  app.UseSwaggerUI();
}

app.UseAuthorization();
app.UseAuthentication();

app.MapPost("/auth", AuthLogic.Auth)
.AllowAnonymous()
.WithOpenApi();

var person = app.MapGroup("/person").WithOpenApi();

person.MapPost("/", PersonLogic.Create)
.AllowAnonymous();

AppDataConnection.Init(connection, app.Logger);

app.Run();
