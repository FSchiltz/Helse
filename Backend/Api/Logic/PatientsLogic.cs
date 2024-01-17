
using Api.Data;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

public static class PatientsLogic
{
    /// <summary>
    /// Get the list of person the caller can manage
    /// </summary>
    /// <param name="db"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetPatientsAsync(AppDataConnection db, HttpContext context)
    {
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        var now = DateTime.UtcNow;
        var persons = await (from u in db.GetTable<Data.Models.Person>()
                             join r in db.GetTable<Data.Models.Right>() on u.Id equals r.PersonId
                             where r.Stop == null || r.Stop >= now && r.Start <= now
                             where r.UserId == user.Id
                             where r.Type == (int)RightType.View
                             select u).Distinct().ToListAsync();

        var models = persons.Select(x =>
        {
            return new Models.Person
            {
                Id = x.Id,
                Birth = x.Birth,
                Name = x.Name,
                Surname = x.Surname,
                Identifier = x.Identifier,
                Type = Api.Models.UserType.Patient,
            };
        });

        return TypedResults.Ok(models);
    }

    public async static Task<IResult> GetAgendaAsync(DateTime start, DateTime end, AppDataConnection db, HttpContext context)
    {        
        var (error, user) = await db.GetUser(context);
        if (error is not null)
            return error;

        var id = user.PersonId;
        var events = await (from e in db.GetTable<Data.Models.Event>()
                            join r in db.GetTable<Data.Models.Right>() on e.PersonId equals r.PersonId
                            where e.Start <= end && start <= e.Stop
                            where r.UserId == user.Id && r.Type == (int)RightType.View
                            select e)
            .ToListAsync();

        return TypedResults.Ok(events.Select(x => new Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = x.Stop,
            File = x.FileId,
            Start = x.Start,
            Valid = x.Valid,
        }));
    }

}