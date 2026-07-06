using System.Net;
using Helse.Api.Data;
using Helse.Api.Helpers;
using Helse.Models.Events;
using Helse.Models.Persons;
using Helse.Models.Settings;
using LinqToDB;

namespace Helse.Api.Logic;

internal static class PatientsLogic
{
    public static RouteGroupBuilder MapPatients(this RouteGroupBuilder api)
    {
        var patients = api.MapGroup("/patients").RequireAuthorization();
        patients.MapGet("/", GetPatientsAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapPut("/", UpdatePatient)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/agenda", GetAgendaAsync)
        .Produces<List<Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/share", SharePatient)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/settings", GetPatientsSettings)
        .Produces<PatientsSettings>((int)HttpStatusCode.OK)
       .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapPost("/settings", PostPatientsSettingsAsync)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);

       return api;
    }


    public static async Task<IResult> GetPatientsSettings(IUserContext users, ISettingsContext settings, IMetricContext metrics, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        var data = await settings.GetSettings<PatientsSettings>(PatientsSettings.Name, user.Id);
        await SettingsLogic.Upgrade(data, metrics, events);
        return error ?? TypedResults.Ok(data);
    }

    /// <summary>
    /// Update the patients settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostPatientsSettingsAsync(PatientsSettings settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var (error, user) = await users.GetUser(context.User);
        return error ?? await db.Save(settings, user.Id, log);
    }

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
                ProfilePicture = x.ProfilePicture,
                Types = [],
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

    public async static Task<IResult> GetAgendaAsync(DateTime start, DateTime end, IUserContext users, IEventContext db, HttpContext context)
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
            Start = x.Start,
            Valid = x.Valid,
            Person = x.PersonId,
            Tag = x.Tag
        }));
    }

    public async static Task<IResult> UpdatePatient(UpdatePatient update, IUserContext users, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        // to update a patient, the user need to have write access to it
        if (!await users.ValidateCaregiverAsync(user, update.Id, RightType.Edit))
            return TypedResults.Forbid();

        await users.UpdatePatient(update);

        return TypedResults.NoContent();
    }
}