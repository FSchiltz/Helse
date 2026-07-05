using Helse.Api.Data;
using Helse.Api.Data.Models.Health;
using Helse.Api.Data.Models.Persons;
using LinqToDB;
using LinqToDB.Async;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class HealthContextTests(DatabaseFixture fixture) : ContextTests(fixture)
{
}