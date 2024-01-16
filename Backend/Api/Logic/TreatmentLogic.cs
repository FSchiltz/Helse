using Api.Data;
using Api.Helpers;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Management of the users and rights
/// </summary>
public static class TreatmentLogic
{
    public static async Task<IResult> GetTypeAsync(AppDataConnection db)
       => TypedResults.Ok(await db.GetTable<Data.Models.EventType>().Where(x => !x.StandAlone).ToListAsync());

    public async static Task<IResult> PostAsync(Models.CreateTreatment treatment, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        // check the personId

        if (treatment.PersonId is not null
         && treatment.PersonId != user.PersonId
          && !await db.ValidateCaregiverAsync(user, treatment.PersonId.Value, RightType.Edit))
            return TypedResults.Forbid();

        // TODO lock only the tables
        using var transaction = await db.BeginTransactionAsync();

        // create the treament
        var id = await db.GetTable<Data.Models.Treatment>().InsertWithInt64IdentityAsync(() => new Data.Models.Treatment
        {
            PersonId = treatment.PersonId ?? user.PersonId,
            Type = (int)TreatmentType.Care,
        });

        // create the events
        // TODO bulk insert
        foreach (var e in treatment.Events)
        {
            await db.GetTable<Data.Models.Event>().InsertAsync(() => new Data.Models.Event
            {
                PersonId = treatment.PersonId ?? user.PersonId,
                UserId = user.Id,
                Type = e.Type,
                Description = e.Description,
                Stop = e.Stop,
                Start = e.Start,
                TreatmentId = id,
            });
        }

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    public async static Task<IResult> GetAsync(DateTime start, DateTime end, long? personId, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await db.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var events = await db.GetTable<Data.Models.Event>()
            .Where(x => x.PersonId == id
                && x.TreatmentId != null
                && x.Start <= end && start <= x.Stop)
            .ToListAsync();

        return TypedResults.Ok(events.GroupBy(x => x.TreatmentId).Select(t => new Treatement
        {
            Events = t.Select(x => new Models.Event
            {
                Id = x.Id,
                Type = x.Type,
                Description = x.Description,
                Stop = x.Stop,
                File = x.FileId,
                Start = x.Start,
                Valid = x.Valid,
            }).ToList()
        }));
    }
}