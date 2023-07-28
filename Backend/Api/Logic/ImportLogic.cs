
using System.ComponentModel;
using Api.Data;
using Api.Helpers;
using Api.Logic.Import;
using LinqToDB;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace Api.Logic;

public enum FileTypes
{
  None = 0,

  [Description("Redmi watch fitness file")]
  RedmiWatch,
}

public record FileType(int Type, string? Name);

/// <summary>
/// Logic for the import of file
/// </summary>
public static class ImportLogic
{
  public static IResult GetTypeAsync()
    => TypedResults.Ok(Enum.GetValues<FileTypes>().Select(x => new FileType((int)x, Helper.DescriptionAttr(x))));

  public static async Task<IResult> PostFileAsync([FromBody]string file, int type,  AppDataConnection db, HttpContext context)
  {
    // get the connected user
    var userName = context.User.GetUser();
    var user = await db.GetTable<Data.Models.User>().FirstOrDefaultAsync(x => x.Identifier == userName);
    if (user is null)
      return TypedResults.Unauthorized();

    FileImporter importer = (FileTypes)type switch
    {
      FileTypes.RedmiWatch => new RedmiWatch(file, db, user),
      _ => throw new NotSupportedException("Invalid file type"),
    };

    await importer.Import();

    return TypedResults.NoContent();
  }
}