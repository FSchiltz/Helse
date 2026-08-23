namespace Helse.Api.Configuration;

internal sealed class DatabaseConfig
{
    public const string Name = "Database";

    public string? Postgres {get;set;}

    public string? Sqlite {get;set;}
}