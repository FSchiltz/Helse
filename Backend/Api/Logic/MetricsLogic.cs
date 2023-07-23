using Api.Data;
using Api.Helpers;
using Api.Models;
using LinqToDB;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class MetricsLogic
{
    public static async Task<IResult> CreateAsync(Metric metric, long? personId, AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return TypedResults.Unauthorized();

        if (personId is not null)
        {
            // only caregiver can add to other user
            if (user.Type != (int)UserType.Caregiver)
            {
                var now = DateTime.UtcNow;
                // check if the user has the right 
                var right = await AuthLogic.HasRightAsync(user.Id, personId.Value, RightType.Edit, now, db);
            }
            else
                return TypedResults.Unauthorized();
        }

        await db.GetTable<Data.Models.Metric>().InsertAsync(() => new Data.Models.Metric
        {
            PersonId = personId ?? user.PersonId,
            Value = metric.Value,
            Date = metric.Date,
            Unit = metric.Unit,
            UserId = user.Id,
        });

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return TypedResults.Unauthorized();

        using var transaction = db.BeginTransaction();

        var existing = await db.GetTable<Data.Models.Metric>().FirstOrDefaultAsync(x => x.Id == id);
        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId)
        {
            // only caregiver can delete for other user
            if (user.Type != (int)UserType.Caregiver)
            {
                var now = DateTime.UtcNow;
                // check if the user has the right 
                var right = await AuthLogic.HasRightAsync(user.Id, existing.PersonId, RightType.Edit, now, db);
            }
            else
                return TypedResults.Unauthorized();
        }

        await db.GetTable<Data.Models.Metric>().DeleteAsync(x => x.Id == id);

        transaction.Commit();

        return TypedResults.NoContent();
    }

    internal async static Task<IResult> GetAsync(long type, DateTime start, DateTime end, long? personId, AppDataConnection db, HttpContext context)
    {
        // get the connected user
        var userName = context.User.GetUser();

        var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
        if (user is null)
            return TypedResults.Unauthorized();

        if (personId is not null)
        {
            // only caregiver can get for other user
            if (user.Type != (int)UserType.Caregiver)
            {
                var now = DateTime.UtcNow;
                // check if the user has the right 
                var right = await AuthLogic.HasRightAsync(user.Id, personId.Value, RightType.View, now, db);
            }
            else
                return TypedResults.Unauthorized();
        }

        var metrics = await db.GetTable<Data.Models.Metric>()
            .Where(x => x.PersonId == user.PersonId
                && x.Type == type
                && x.Date <= end && x.Date >= start)
            .ToListAsync();
            
        return TypedResults.Ok(metrics);
    }
}