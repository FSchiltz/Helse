using System.Net;
using Helse.Models.Settings;
using Helse.Models.Settings.Admin;
using Helse.Models.Persons;
using Helse.Models.Metrics;
using Helse.Models.Imports;
using Helse.Models.Events;
using Helse.Models.Common;
using Helse.Models.Admin;
using Helse.Api.Logic;
using Helse.Api.Jobs;

namespace Helse.Api;

internal static class Endpoints
{
    public static void MapAuth(this RouteGroupBuilder api)
    {
        /* User endpoints */
        api.MapPost("/auth", AuthLogic.AuthAsync)
        .AllowAnonymous()
        .WithDescription("Get a connection token")
        .Produces<ConnectionResponse>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/refresh", AuthLogic.RefreshAsync)
        .RequireAuthorization()
        .Produces<ConnectionResponse>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/status", AuthLogic.StatusAsync)
        .AllowAnonymous()
        .WithDescription("Check if the server install is ready")
        .Produces<Status>((int)HttpStatusCode.OK);

        api.MapGet("/logout", AuthLogic.LogoutAsync)
        .RequireAuthorization()
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/sessions", AuthLogic.GetSessions)
        .RequireAuthorization()
        .Produces<Session[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapPerson(this RouteGroupBuilder api)
    {
        var person = api.MapGroup("/person").RequireAuthorization();

        person.MapPost("/", PersonLogic.CreateAsync)
        .AllowAnonymous()
        .Produces<UserId>((int)HttpStatusCode.Created)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapGet("/", PersonLogic.GetAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapDelete("/{userId}", PersonLogic.DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapGet("/caregiver", PersonLogic.GetCaregiverAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapPut("/", PersonLogic.UpdatePersonAsync)
            .Produces((int)HttpStatusCode.Unauthorized)
            .Produces((int)HttpStatusCode.NoContent);

        person.MapGet("/settings", SettingsLogic.GetUserSettings)
        .Produces<UserSettings>((int)HttpStatusCode.OK)
       .Produces((int)HttpStatusCode.Unauthorized);

        person.MapPost("/settings", SettingsLogic.PostUserSettingsAsync)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);

        var rights = person.MapGroup("/rights");
        rights.MapPost("/{personId}", PersonLogic.SetRight)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapPatients(this RouteGroupBuilder api)
    {
        var patients = api.MapGroup("/patients").RequireAuthorization();
        patients.MapGet("/", PatientsLogic.GetPatientsAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapPut("/", PatientsLogic.UpdatePatient)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/agenda", PatientsLogic.GetAgendaAsync)
        .Produces<List<Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/share", PatientsLogic.SharePatient)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/settings", SettingsLogic.GetPatientsSettings)
        .Produces<PatientsSettings>((int)HttpStatusCode.OK)
       .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapPost("/settings", SettingsLogic.PostPatientsSettingsAsync)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapAdmin(this RouteGroupBuilder api)
    {
        var admin = api.MapGroup("/admin").RequireAuthorization();

        var settings = admin.MapGroup("/settings").RequireAuthorization();
        settings.MapPost("/oauth", SettingsLogic.PostOauthAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/oauth", SettingsLogic.GetOauthAsync)
            .Produces<Oauth>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/proxy", SettingsLogic.PostProxyAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/proxy", SettingsLogic.GetProxyAsync)
            .Produces<Proxy>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/smtp", SettingsLogic.PostSmtpAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/gotify", SettingsLogic.GetGotifyAsync)
            .Produces<Gotify>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/gotify", SettingsLogic.PostGotifyAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/smtp", SettingsLogic.GetSmtpAsync)
            .Produces<Smtp>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/jobs", ImportLogic.GetAllJobsAsync)
            .Produces<JobResult[]>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        var stats = admin.MapGroup("/stats").RequireAuthorization();
        stats.MapGet("/users", AdminLogic.GetUserStatsAsync)
            .Produces<UserCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        stats.MapGet("/events", AdminLogic.GetEventStatsAsync)
            .Produces<EventCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        stats.MapGet("/metrics", AdminLogic.GetMetricStatsAsync)
            .Produces<MetricCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapCommon(this RouteGroupBuilder api)
    {
        api.MapGet("/units", CommonLogic.GetUnitsAsync)
        .RequireAuthorization()
        .Produces<Unit[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapImports(this RouteGroupBuilder api)
    {
        /* Importer endpoint */
        var import = api.MapGroup("/import").RequireAuthorization();
        import.MapGet("/types", ImportLogic.GetImportTypes)
            .Produces<List<FileType>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/{type}", ImportLogic.PostFileAsync)
            .DisableAntiforgery()
            .Produces<JobId>((int)HttpStatusCode.Accepted)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/jobs/all", ImportLogic.GetAllJobsAsync)
            .Produces<JobResultInfo[]>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/jobs", ImportLogic.GetJobsAsync)
            .Produces<JobResultInfo[]>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapGet("/{id:Guid}", ImportLogic.GetJobResultAsync)
            .Produces<JobResult>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.NotFound)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/", ImportLogic.PostListAsync)
            .Produces<ImportsResult>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapEnpoints(this RouteGroupBuilder api)
    {
        api.MapAuth();
        api.MapPerson();
        api.MapPatients();
        api.MapCommon();

        api.MapMetrics();
        api.MapEvents();

        api.MapAdmin();

        api.MapImports();
    }
}