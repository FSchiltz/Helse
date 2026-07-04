using System.Net;
using Helse.Api.Data;
using Helse.Api.Helpers;
using Helse.Api.Mappers;
using Helse.Models.Common;
using Helse.Models.Events;
using Helse.Models.Persons;
using LinqToDB;
using Microsoft.AspNetCore.Mvc;

namespace Helse.Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
internal static class EventsLogic
{
    public static RouteGroupBuilder MapEvents(this RouteGroupBuilder api)
    {
        /* Events endpoints*/
        var events = api.MapGroup("/events").RequireAuthorization();

        events.MapGet("/summary", GetSummaryAsync)
        .Produces<EventStats>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapGet("/", GetAsync)
        .Produces<List<Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPost("/", CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPut("/", UpdateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapDelete("/{id}", DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPut("/update", UpdateBulkAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPost("/delete", DeleteBulkAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPost("/search", SearchAsync)
        .Produces<Event[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPost("/count", CountAsync)
        .Produces<long>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        var eventsType = events.MapGroup("/type").RequireAuthorization();
        eventsType.MapPost("/", CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        eventsType.MapPut("/", UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        eventsType.MapDelete("/{id}", DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        eventsType.MapGet("/", GetTypeAsync)
        .Produces<List<EventType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var result = (await events.GetEvents(id, type, start, end)).Select(EventMapper.Map);

        return TypedResults.Ok(result);
    }

    public async static Task<IResult> GetSummaryAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IEventContext events, HttpContext context)
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

    public static async Task<IResult> CreateAsync(CreateEvent e, long? personId, IUserContext users, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        Validate(e);

        await events.Insert(e, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    private static void Validate(BaseEvent e)
    {
        if (e.Stop < e.Start)
        {
            throw new InvalidDataException("The end date must be before the start");
        }
    }

    public static async Task<IResult> UpdateAsync(UpdateEvent e, IUserContext users, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var existing = await events.GetEvent(e.Id) ?? throw new InvalidDataException("Id not found");

        if (existing.PersonId != user.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        Validate(e);
        await events.Update(e);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateBulkAsync(PatchEvent e, long? personId, IUserContext users, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        personId ??= user.PersonId;

        if (personId != user.PersonId && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        Validate(e);
        await events.UpdateBulk(e, personId.Value);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, IUserContext users, IEventContext events, HttpContext context)
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

    public async static Task<IResult> DeleteBulkAsync([FromBody] long[] ids, long? person, IUserContext users, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;


        person ??= user.PersonId;
        if (user.PersonId != person && !await users.ValidateCaregiverAsync(user, person.Value, RightType.Edit))
            return TypedResults.Forbid();

        await events.DeleteEvents(ids, person.Value);


        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool? all, IEventContext events)
    => TypedResults.Ok((await events.GetEventTypes(all)).Select(EventMapper.Map));

    public static async Task<IResult> CreateTypeAsync(CreateEventType type, IUserContext users, IEventContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await events.Insert(type);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(UpdateEventType type, IUserContext users, IEventContext events, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await events.Update(type);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, IUserContext users, IEventContext events, HttpContext context)
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

    internal static async Task<IResult> SearchAsync(SearchEvent search, long? personId, [AsParameters] Pagination pagination, IUserContext users, IEventContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var results = await db.SearchEventsAsync(id, search, pagination);
        return TypedResults.Ok(results.Select(EventMapper.Map));
    }

    internal static async Task<IResult> CountAsync(SearchEvent search, long? personId, IUserContext users, IEventContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var results = await db.CountEventsAsync(id, search);
        return TypedResults.Ok(results);
    }
}