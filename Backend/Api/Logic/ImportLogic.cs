using Helse.Api.Data;
using Helse.Api.Helpers;
using Helse.Models.Imports;
using Helse.Models.Persons;
using LinqToDB;
using Microsoft.AspNetCore.Mvc;
using Helse.Api.Logic.Import;
using Helse.Api.Jobs;
using System.Net;

namespace Helse.Api.Logic;

/// <summary>
/// Logic for the import of file
/// </summary>
internal static class ImportLogic
{
    public static RouteGroupBuilder MapImports(this RouteGroupBuilder api)
    {
        /* Importer endpoint */
        var import = api.MapGroup("/import").RequireAuthorization();
        import.MapGet("/types", GetImportTypes)
            .Produces<List<ImportType>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/{type}", PostFileAsync)
            .DisableAntiforgery()
            .Produces<JobId>((int)HttpStatusCode.Accepted)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/jobs/all", GetAllJobsAsync)
            .Produces<JobResultInfo[]>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/jobs", GetJobsAsync)
            .Produces<JobResultInfo[]>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/{id:Guid}", GetJobResultAsync)
            .Produces<JobResult>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.NotFound)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/results", PostListAsync)
            .Produces<ImportsResult>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    public static IResult GetImportTypes()
      => TypedResults.Ok(Enum.GetValues<ImportTypes>().Select(x => new ImportType((int)x, x.DescriptionAttr())));

    public static async Task<IResult> GetJobResultAsync([FromRoute] Guid id, IImportQueue queue, IUserContext users, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var result = queue.GetResult(id);
        if (result.UserId != user.Id)
        {
            return TypedResults.NotFound();
        }

        return TypedResults.Ok(result);
    }

    public static async Task<IResult> GetJobsAsync(IImportQueue queue, IUserContext users, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var results = queue.GetJobs().Where(x => x.Result.UserId == user.Id);

        return TypedResults.Ok(results);
    }

    public static async Task<IResult> GetAllJobsAsync(IImportQueue queue, IUserContext users, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var results = queue.GetJobs();

        return TypedResults.Ok(results);
    }

    public static async Task<IResult> PostFileAsync([FromForm] IFormFile file, [FromRoute] int type, [FromQuery] long? patient, IUserContext users, IImportQueue queue, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        long person;
        if (patient is not null)
        {
            if (!await users.ValidateCaregiverAsync(user, patient.Value, RightType.Edit))
            {
                return TypedResults.Forbid();
            }
            person = patient.Value;
        }
        else
        {
            person = user.Id;
        }

        // generate a task id
        var id = Guid.NewGuid();

        // add the job in the queue  
        await using var stream = file.OpenReadStream();
        MemoryStream ms = new();
        // save the data so the background job does not fail
        await stream.CopyToAsync(ms);
        ms.Position = 0;
        var fileType = (ImportTypes)type;

        queue.Enqueue(new ImporterService.Job(id, ms, fileType, user.Id, person), $"Import from {fileType}{(patient is not null ? $" for {patient}" : string.Empty)}");

        // return the jobid
        return TypedResults.Created(default(string), new JobId(id));
    }

    public static async Task<IResult> PostListAsync([FromBody] ImportData file, [FromQuery] long? patient, IUserContext users, IMetricContext metricDb, IEventContext eventDb, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        long person;
        if (patient is not null)
        {
            if (!await users.ValidateCaregiverAsync(user, patient.Value, RightType.Edit))
            {
                return TypedResults.Forbid();
            }
            person = patient.Value;
        }
        else
        {
            person = user.Id;
        }

        Importer importer = new ListImporter(file, eventDb, metricDb, user.Id, person);
        var results = await importer.Import(new LocalQueue(), Guid.NewGuid());

        // TODO return a asyncenumerable to stream the progress
        return TypedResults.Ok(results);
    }
}
