using Helse.Api.Data;
using LinqToDB;
using LinqToDB.Data;
using LinqToDB.Mapping;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Data;

public abstract class ContextTests(DatabaseFixture fixture)
{
    private protected readonly SlowQueryLogInterceptor _interceptor = new(
        Substitute.For<ILogger<SlowQueryLogInterceptor>>());

    protected async Task<DataConnection> GetDb()
    {
        var temp = await fixture.GetTempDB();
        var mapper = new MappingSchema(); mapper.SetConverter<DateTime, DateTime>(x => DateTime.SpecifyKind(x, DateTimeKind.Utc));

        var db = new DataConnection(new DataOptions().UsePostgreSQL(temp).UseMappingSchema(mapper));

        await DatabaseFixture.InitForUnit(db);
        return db;
    }
}
