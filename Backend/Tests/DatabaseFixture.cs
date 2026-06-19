using Helse.Api.Data.Models.Common;
using Helse.Api.Data.Models.Health;
using Helse.Api.Data.Models.Persons;
using DotNet.Testcontainers.Containers;
using LinqToDB;
using LinqToDB.Data;
using Testcontainers.PostgreSql;

namespace Tests;

[CollectionDefinition("Database collection")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
    // This class has no code, and is never created. Its purpose is simply
    // to be the place to apply [CollectionDefinition] and all the
    // ICollectionFixture<> interfaces.
}

public class DatabaseFixture : IAsyncLifetime
{
    IContainer? container;

    public int Port { get; private set; }


    public async ValueTask DisposeAsync()
    {
        if (container is not null)
        {
            await container.StopAsync();
        }
    }

    public async ValueTask InitializeAsync()
    {
        // Create a new instance of a container.
        container = new PostgreSqlBuilder("postgres:15.1")
          .WithPortBinding(5432, true)
          .WithEnvironment("POSTGRES_USER", "postgres")
          .WithEnvironment("POSTGRES_PASSWORD", "postgres")
          .WithEnvironment("POSTGRES_DB", "helse")
          .Build();

        // Start the container.
        await container.StartAsync();

        Port = container.GetMappedPublicPort(5432);
    }

    private string GetDatabaseConnection(string? name)
    {
        return $"Server={container?.Hostname};Port={Port};{(name is null ? "" : $"Database={name};")}User Id=postgres;Password=postgres; Include Error Detail=true";
    }

    private static readonly Random random = new();

    private static string RandomString(int length)
    {
        const string chars = "abcdefghijklmnopqrstuvwxyz";
        return new string([.. Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)])]);
    }

    internal async Task<string> GetTempDB()
    {
        string name = RandomString(10);
        await using var _db = new DataConnection(x => new DataOptions().UsePostgreSQL(GetDatabaseConnection(null)));
        var result = await _db.ExecuteAsync($"CREATE DATABASE {name};");

        return GetDatabaseConnection(name);
    }

    internal static async Task InitForUnit(DataConnection db)
    {
        await db.ExecuteAsync("CREATE SCHEMA health;");
        await db.ExecuteAsync("CREATE SCHEMA person;");
        await db.ExecuteAsync("CREATE SCHEMA common;");
        await db.ExecuteAsync("CREATE SCHEMA admin;");
        await db.CreateTableAsync<Event>();
        await db.CreateTableAsync<EventType>();
        await db.CreateTableAsync<Metric>();
        await db.CreateTableAsync<MetricType>();
        await db.CreateTableAsync<Person>();
        await db.CreateTableAsync<User>();
        await db.CreateTableAsync<Units>();
        await db.CreateTableAsync<MetricGroup>();
        await db.CreateTableAsync<Right>();
        await db.CreateTableAsync<Settings>();
        await db.CreateTableAsync<Helse.Api.Data.Models.Admin.Settings>();
    }
}
