using System.Text;
using Api;
using Api.Data;
using Api.Helpers;
using Api.Helpers.Auth;
using LinqToDB;
using LinqToDB.AspNet;
using LinqToDB.AspNet.Logging;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Unchase.Swashbuckle.AspNetCore.Extensions.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddEnumsWithValuesFixFilters();
    // Configure swagger to use the jwt
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Helse Api",
        Version = "v1"
    });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement {
    {
      new OpenApiSecurityScheme {
          Reference = new OpenApiReference {
              Type = ReferenceType.SecurityScheme,
              Id = "Bearer"
          }
      },
      Array.Empty<string>()
    }
  });
});

//services cors
builder.Services.AddCors(p => p.AddPolicy("corsapp", builder =>
{
    builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader();
}));

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
          ValidateIssuerSigningKey = false,
          ClockSkew = TimeSpan.Zero
      };
  });

builder.Services.AddAuthorizationBuilder()
    .SetDefaultPolicy(new AuthorizationPolicyBuilder()
            .RequireClaim("token", ["access"])
            .Build());

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("corsapp");
app.UseAuthentication();
app.UseAuthorization();

app.UseDefaultFiles();
app.UseStaticFiles();

var api = app.MapGroup("/api");
api.MapEnpoints();

AppDataConnection.Init(connection, app.Logger);

app.Run();
