using Api.Data;
using Api.Helpers;
using Api.Models.Events;
using Api.Models.Imports;
using Api.Models.Persons;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class EventsLogic
{
    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var result = (await events.GetEvents(id, type, start, end))
        .Select(x => new Models.Events.Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = DateTime.SpecifyKind(x.Stop, DateTimeKind.Utc),
            File = x.FileId,
            Start = DateTime.SpecifyKind(x.Start, DateTimeKind.Utc),
            Valid = x.Valid,
            NotificationTime = x.NotificationTime,
            Source = (FileTypes)x.Source,
            SourceId = x.SourceId,
            Tag = x.Tag,
        });

        return TypedResults.Ok(result);
    }

    public async static Task<IResult> GetSummaryAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var data = await events.GetEvents(id, type, start, end);

        return TypedResults.Ok(data.Summarize(start, end));
    }

    public static async Task<IResult> CreateAsync(CreateEvent e, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        await events.Insert(e, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateAsync(UpdateEvent e, long? personId, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var existing = await events.GetEvent(e.Id) ?? throw new InvalidDataException("Id not found");

        if (existing.PersonId != user.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await events.Update(e);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, IUserContext users, IHealthContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        await using var transaction = await users.BeginTransactionAsync();

        var existing = await events.GetEvent(id);

        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await events.DeleteEvent(id);

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool? all, IHealthContext events) => TypedResults.Ok((await events.GetEventTypes(all)).Select(x => new EventType
    {
        Name = x.Name,
        Description = x.Description,
        Id = x.Id,
        StandAlone = x.StandAlone,
        Visible = x.Visible,
        UserEditable = x.UserEditable,
    }));

    public static async Task<IResult> CreateTypeAsync(EventType type, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await events.Insert(type);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(EventType type, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await events.Update(type);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, IUserContext users, IHealthContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var count = await events.DeleteEventType(id);

        if (count == 1)
            return TypedResults.NoContent();
        else
            return TypedResults.BadRequest();
    }
}