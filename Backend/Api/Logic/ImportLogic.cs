using Api.Data;
using Api.Helpers;
using Api.Logic.Auth;
using Api.Logic.Import;
using Api.Models;
using LinqToDB;
using Microsoft.AspNetCore.Mvc;

namespace Api.Logic;

public record FileType(int Type, string? Name);

/// <summary>
/// Logic for the import of file
/// </summary>
public static class ImportLogic
{
    public static IResult GetTypeAsync()
      => TypedResults.Ok(Enum.GetValues<FileTypes>().Select(x => new FileType((int)x, Helper.DescriptionAttr(x))));

    public static async Task<IResult> PostFileAsync([FromBody] string file, int type, AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        FileImporter importer = (FileTypes)type switch
        {
            FileTypes.RedmiWatch => new RedmiWatch(file, db, user),
            _ => throw new NotSupportedException("Invalid file type"),
        };

        await importer.Import();

        return TypedResults.NoContent();
    }
}
