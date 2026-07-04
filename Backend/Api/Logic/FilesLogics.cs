using System.Net;

namespace Helse.Api.Logic;

internal static class FilesLogics
{
    public static RouteGroupBuilder MapFiles(this RouteGroupBuilder api)
    {
        var files = api.MapGroup("/files").RequireAuthorization();

        files.MapGet("/{id}", GetFileAsync)
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
        metrics.MapGet("/{id}", GetMetricFilesAsync)
        .Produces<Models.Files.File[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/{metricid}/{fileid}", LinkMetricAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapDelete("/{metricid}/{fileid}", UnlinkMetricAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        var events = files.MapGroup("/events").RequireAuthorization();
        events.MapGet("/{id}", GetEventFilesAsync)
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

}
