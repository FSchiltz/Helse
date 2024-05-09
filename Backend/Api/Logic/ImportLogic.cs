using Api.Data;
using Api.Helpers;
using Api.Logic.Import;
using Api.Models;
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

    public static async Task<IResult> PostFileAsync([FromBody] string file, int type, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        Importer importer = (FileTypes)type switch
        {
            FileTypes.RedmiWatch => new RedmiWatch(file, db, user),
            _ => throw new NotSupportedException("Invalid file type"),
        };

        await importer.Import();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> PostListAsync([FromBody] ImportData file, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        Importer importer = new ListImporter(file, db, user);

        await importer.Import();

        return TypedResults.NoContent();
    }
}
