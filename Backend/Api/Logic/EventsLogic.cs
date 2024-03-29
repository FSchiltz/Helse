using Api.Data;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class EventsLogic
{
    public async static Task<IResult> GetAsync(int? type, DateTime start, DateTime end, long? personId, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var events = await db.GetTable<Data.Models.Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();

        return TypedResults.Ok(events.Select(x => new Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = x.Stop,
            File = x.FileId,
            Start = x.Start,
            Valid = x.Valid,
        }));
    }

    public static async Task<IResult> CreateAsync(CreateEvent e, long? personId, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        await db.GetTable<Data.Models.Event>().InsertAsync(() => new Data.Models.Event
        {
            PersonId = personId ?? user.PersonId,
            UserId = user.Id,
            Type = e.Type,
            Description = e.Description,
            Stop = e.Stop,
            Start = e.Start,
        });

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        using var transaction = db.BeginTransaction();

        var existing = await db.GetTable<Data.Models.Event>().FirstOrDefaultAsync(x => x.Id == id);
        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId && !await db.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await db.GetTable<Data.Models.Event>().DeleteAsync(x => x.Id == id);

        transaction.Commit();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(AppDataConnection db)
        => TypedResults.Ok(await db.GetTable<Data.Models.EventType>().Where(x => x.StandAlone).ToListAsync());

    public static async Task<IResult> CreateTypeAsync(Data.Models.EventType metric, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.MetricType>().InsertAsync(() => new Data.Models.MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
        });

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(Data.Models.MetricType metric, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.EventType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .UpdateAsync();

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, AppDataConnection db, HttpContext context)
    {
        var admin = await db.IsAdmin(context);
        if (admin is not null)
            return admin;

        await db.GetTable<Data.Models.EventType>().DeleteAsync(x => x.Id == id);

        return TypedResults.NoContent();
    }
}