using Api.Data;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class MetricsLogic
{
    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var metrics = await db.GetTable<Data.Models.Metric>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
            .ToListAsync();

        return TypedResults.Ok(metrics.Select(x => new Metric
        {
            Value = x.Value,
            Date = x.Date,
            Id = x.Id,
            Person = user.PersonId,
            Type = x.Type,
            Tag = x.Tag,
            User = x.UserId,
        }));
    }

    public static async Task<IResult> CreateAsync(CreateMetric metric, long? personId, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        await db.GetTable<Data.Models.Metric>().InsertAsync(() => new Data.Models.Metric
        {
            PersonId = personId ?? user.PersonId,
            Value = metric.Value,
            Date = metric.Date,
            Tag = metric.Tag,
            UserId = user.Id,
            Type = metric.Type,
        });

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        using var transaction = db.BeginTransaction();

        var existing = await db.GetTable<Data.Models.Metric>().FirstOrDefaultAsync(x => x.Id == id);
        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId && !await db.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await db.GetTable<Data.Models.Metric>().DeleteAsync(x => x.Id == id);

        transaction.Commit();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(AppDataConnection db)
        => TypedResults.Ok(await db.GetTable<Data.Models.MetricType>().ToListAsync());

    public static async Task<IResult> CreateTypeAsync(Data.Models.MetricType metric, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.MetricType>().InsertAsync(() => new Data.Models.MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            Unit = metric.Unit,
        });

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(Data.Models.MetricType metric, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.MetricType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .Set(x => x.Unit, metric.Unit)
            .UpdateAsync();

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.MetricType>().DeleteAsync(x => x.Id == id);

        return TypedResults.NoContent();
    }
}