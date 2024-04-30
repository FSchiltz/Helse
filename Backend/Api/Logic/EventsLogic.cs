using Api.Data;
using Api.Helpers;
using Api.Logic.Auth;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class EventsLogic
{
    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var result = (await events.GetEvents(id, type, start, end))
        .Select(x => new Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = x.Stop,
            File = x.FileId,
            Start = x.Start,
            Valid = x.Valid,
        });

        return TypedResults.Ok(result);
    }

    public static async Task<IResult> CreateAsync(CreateEvent e, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        await events.Insert(e, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context);
        if (error is not null)
            return error;

        await using var transaction = await users.BeginTransactionAsync();

        var existing = await events.GetEvent(id);

        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await events.DeleteEvent(id);

        transaction.Commit();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool all, IHealthContext events) => TypedResults.Ok(await events.GetEventTypes(all));

    public static async Task<IResult> CreateTypeAsync(Data.Models.EventType type, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context);
        if (admin is not null)
            return admin;

        await events.Insert(type);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(Data.Models.EventType type, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context);
        if (admin is not null)
            return admin;

        await events.Update(type);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context);
        if (admin is not null)
            return admin;

        await events.DeleteEventType(id);

        return TypedResults.NoContent();
    }
}