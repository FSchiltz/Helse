using Api.Data;
using Api.Helpers;
using Api.Models.Events;
using Api.Models.Persons;
using Api.Models.Treatments;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Management of the users and rights
/// </summary>
public static class TreatmentLogic
{
    public static async Task<IResult> GetTypeAsync(IEventContext db)
     => TypedResults.Ok(await db.GetEventTypes(false, true));

    public async static Task<IResult> PostAsync(CreateTreatment treatment, IUserContext db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context.User);
        if (error is not null)
            return error;

        // check the personId

        if (treatment.PersonId is not null
         && treatment.PersonId != user.PersonId
          && !await db.ValidateCaregiverAsync(user, treatment.PersonId.Value, RightType.Edit))
        {
            return TypedResults.Forbid();
        }

        // TODO lock only the tables
        await using var transaction = await db.BeginTransactionAsync();

        // create the treament
        var id = await db.InsertTreatment(treatment.PersonId ?? user.PersonId, TreatmentType.Care);

        // create the events
        // TODO bulk insert
        foreach (var e in treatment.Events)
        {
            await db.InsertEvent(e, treatment.PersonId ?? user.PersonId, user.Id, id);
        }

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    public async static Task<IResult> GetAsync(DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var events = await db.GetTreatmentEvents(id, start, end);

        return TypedResults.Ok(events.Select(x => new Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = x.Stop,
            File = x.FileId,
            Start = x.Start,
            Valid = x.Valid,
            SourceId = x.SourceId,
            Person = x.PersonId,
        }));
    }
}