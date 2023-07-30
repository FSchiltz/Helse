using System.Text;
using Api.Data;
using Api.Helpers;
using Api.Logic;
using System.Net;
using LinqToDB;
using LinqToDB.AspNet;
using LinqToDB.AspNet.Logging;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
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
      ValidateLifetime = false,
      ValidateIssuerSigningKey = false
    };
  });

builder.Services.AddAuthorization();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("corsapp");
app.UseAuthentication();
app.UseAuthorization();


var api = app.MapGroup("/api");
/* User endpoints */
api.MapPost("/auth", AuthLogic.AuthAsync)
.AllowAnonymous()
.WithDescription("Get a connection token")
.Produces<string>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

api.MapGet("/status", AuthLogic.StatusAsync)
.AllowAnonymous()
.WithDescription("Check if the server install is ready")
.Produces<Status>((int)HttpStatusCode.OK)
.WithOpenApi();

var person = api.MapGroup("/person");

person.MapPost("/", PersonLogic.CreateAsync)
.AllowAnonymous()
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

/* Metrics endpoints*/
var metrics = api.MapGroup("/metrics");
metrics.MapGet("/", MetricsLogic.GetAsync)
.Produces<List<Api.Models.Metric>>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

metrics.MapPost("/", MetricsLogic.CreateAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

metrics.MapDelete("/{id}", MetricsLogic.DeleteAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

var metricsType = metrics.MapGroup("/type").RequireAuthorization();
metricsType.MapPost("/", MetricsLogic.CreateTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

metricsType.MapPut("/", MetricsLogic.UpdateTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

metricsType.MapDelete("/{id}", MetricsLogic.DeleteTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

metricsType.MapGet("/", MetricsLogic.GetTypeAsync)
.Produces<List<Api.Data.Models.MetricType>>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();


/* Events endpoints*/
var events = api.MapGroup("/events");
events.MapGet("/", EventsLogic.GetAsync)
.Produces<List<Api.Models.Event>>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

events.MapPost("/", EventsLogic.CreateAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

events.MapDelete("/{id}", EventsLogic.DeleteAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

var eventsType = events.MapGroup("/type").RequireAuthorization();
eventsType.MapPost("/", EventsLogic.CreateTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

eventsType.MapPut("/", EventsLogic.UpdateTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

eventsType.MapDelete("/{id}", EventsLogic.DeleteTypeAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

eventsType.MapGet("/", EventsLogic.GetTypeAsync)
.Produces<List<Api.Data.Models.EventType>>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();


/* Importer endpoint */
var import = api.MapGroup("/import");
import.MapGet("/types", ImportLogic.GetTypeAsync)
.Produces<List<FileType>>((int)HttpStatusCode.OK)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

import.MapPost("/{type}", ImportLogic.PostFileAsync)
.Produces((int)HttpStatusCode.NoContent)
.Produces((int)HttpStatusCode.Unauthorized)
.WithOpenApi();

AppDataConnection.Init(connection, app.Logger);

app.Run();
