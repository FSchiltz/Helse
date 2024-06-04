using Api.Data;
using Api.Helpers;
using Api.Models;
using LinqToDB;

namespace Api.Logic;

public static class PatientsLogic
{
    /// <summary>
    /// Get the list of person the caller can manage
    /// </summary>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> GetPatientsAsync(IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var now = DateTime.UtcNow;
        var persons = await db.GetPatients(user.Id, now, RightType.View);

        var models = persons.Select(x =>
        {
            return new Person
            {
                Id = x.Id,
                Birth = x.Birth,
                Name = x.Name,
                Surname = x.Surname,
                Identifier = x.Identifier,
                Type = UserType.Patient,
            };
        });

        return TypedResults.Ok(models);
    }

    /// <summary>
    /// Share a patient between caregiver
    /// </summary>
    public async static Task<IResult> SharePatient(int patient, int caregiver, bool edit, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        // to share a patient, the user need to have write access to it
        if (!await users.ValidateCaregiverAsync(user, patient, RightType.Edit))
            return TypedResults.Forbid();

        await users.AddRight(caregiver, patient, RightType.View);
        if (edit)
        {
            await users.AddRight(caregiver, patient, RightType.Edit);
        }

        return TypedResults.NoContent();
    }

    public async static Task<IResult> GetAgendaAsync(DateTime start, DateTime end, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var id = user.PersonId;
        var events = await db.GetEvents(user.Id, RightType.View, start, end);

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