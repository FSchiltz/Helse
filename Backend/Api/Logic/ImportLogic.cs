using Api.Data;
using Api.Helpers;
using Api.Jobs;
using Api.Logic.Import;
using Api.Models;
using Api.Models.Events;
using Api.Models.Metrics;
using LinqToDB;
using Microsoft.AspNetCore.Mvc;

namespace Api.Logic;

public record FileType(int Type, string? Name);

public class ImportData
{
    public List<CreateMetric> Metrics { get; set; } = [];

    public List<CreateEvent> Events { get; set; } = [];
}

/// <summary>
/// Logic for the import of file
/// </summary>
public static class ImportLogic
{
    public static IResult GetImportTypes()
      => TypedResults.Ok(Enum.GetValues<FileTypes>().Select(x => new FileType((int)x, x.DescriptionAttr())));

    public static async Task<IResult> GetJobResultAsync(Guid id, IImportQueue queue, IUserContext users, HttpContext context)
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

    public static async Task<IResult> PostFileAsync([FromForm] IFormFile file, [FromRoute] int type, IUserContext users, IImportQueue queue, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        // generate a task id
        var id = Guid.NewGuid();

        // add the job in the queue  
        await using var stream = file.OpenReadStream();
        MemoryStream ms = new();
        // save the data so the background job does not fail
        await stream.CopyToAsync(ms);

        queue.Enqueue(new ImporterService.Job(id, ms, (FileTypes)type, user));

        // return the jobid
        return TypedResults.Created(default(string), id);
    }

    public static async Task<IResult> PostListAsync([FromBody] ImportData file, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        Importer importer = new ListImporter(file, db, user);
        await importer.Import(new LocalQueue(), Guid.NewGuid());

        // TODO return a asyncenumerable to stream the progress
        return TypedResults.NoContent();
    }
}
