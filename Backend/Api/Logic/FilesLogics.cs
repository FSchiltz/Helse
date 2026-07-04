using System.Net;
using Helse.Api.Data;
using Helse.Api.Helpers;
using Helse.Models.Common;
using Helse.Models.Files;
using Helse.Models.Persons;

namespace Helse.Api.Logic;

internal static class FilesLogics
{
    public static RouteGroupBuilder MapFiles(this RouteGroupBuilder api)
    {
        var files = api.MapGroup("/files").RequireAuthorization();

        files.MapGet("/{id}", GetFileAsync)
        .Produces<Models.Files.File>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        files.MapGet("/data/{id}", GetDataAsync)
        .Produces<Models.Files.File>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        files.MapGet("/", GetFilesAsync)
        .Produces<List<Models.Files.File>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        files.MapPut("/", UpdateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        files.MapPost("/", CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        files.MapDelete("/{id}", DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        var metrics = files.MapGroup("/metrics").RequireAuthorization();
        metrics.MapGet("/{metricid}", GetMetricFilesAsync)
        .Produces<Models.Files.File[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/{metricid}/{fileid}", LinkMetricAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapDelete("/{metricid}/{fileid}", UnlinkMetricAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        var events = files.MapGroup("/events").RequireAuthorization();
        events.MapGet("/{eventid}", GetEventFilesAsync)
        .Produces<Models.Files.File[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapPost("/{eventid}/{fileid}", LinkEventAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        events.MapDelete("/{eventid}/{fileid}", UnlinkEventAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    private static async Task<IResult> UnlinkEventAsync(long eventId, long fileId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.UnlinkEventAsync(eventId, fileId, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> LinkEventAsync(long eventId, long fileId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.LinkEventAsync(eventId, fileId, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> GetEventFilesAsync(long eventId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.View, context.User);
        if (error is not null)
            return error;

        Models.Files.File[] result = await files.GetFilesByEventAsync(eventId, user);

        return TypedResults.Ok(result);
    }

    private static async Task<IResult> UnlinkMetricAsync(long metricId, long fileId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.UnlinkMetricAsync(metricId, fileId, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> LinkMetricAsync(long metricId, long fileId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.LinkMetricAsync(metricId, fileId, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> GetMetricFilesAsync(long metricId, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.View, context.User);
        if (error is not null)
            return error;

        Models.Files.File[] result = await files.GetFilesByMetricAsync(metricId, user);

        return TypedResults.Ok(result);
    }

    private static async Task<IResult> DeleteAsync(long id, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.DeleteAsync(id, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> CreateAsync(CreateFile file, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.CreateAsync(file, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> UpdateAsync(UpdateFile file, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.Edit, context.User);
        if (error is not null)
            return error;

        await files.UpdateAsync(file, user);

        return TypedResults.NoContent();
    }

    private static async Task<IResult> GetFilesAsync(long? personId, [AsParameters] Pagination pagination, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.View, context.User);
        if (error is not null)
            return error;

        var result = await files.GetAsync(user, pagination);

        return TypedResults.Ok(result);
    }

    private static async Task<IResult> GetFileAsync(long id, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.View, context.User);
        if (error is not null)
            return error;

        var result = await files.GetAsync(id, user);

        return TypedResults.Ok(result);
    }

    private static async Task<IResult> GetDataAsync(long id, long? personId, IUserContext users, IFilesContext files, HttpContext context)
    {
        var (error, user) = await users.ValidateUserOrCaregiver(personId, RightType.View, context.User);
        if (error is not null)
            return error;

        var result = await files.GetDataAsync(id, user);

        return TypedResults.Ok(result);
    }
}
