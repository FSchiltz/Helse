using System.Net;
using Api.Logic;
using Api.Logic.Auth;
using Api.Models.Events;
using Api.Models.Metrics;
using Api.Models.Persons;
using Api.Models.Settings.Admin;
using Api.Models.Treatments;

namespace Api;

public static class Endpoints
{
    public static void MapAuth(this RouteGroupBuilder api)
    {
        /* User endpoints */
        api.MapPost("/auth", AuthLogic.AuthAsync)
        .AllowAnonymous()
        .WithDescription("Get a connection token")
        .Produces<TokenResponse>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        api.MapGet("/status", AuthLogic.StatusAsync)
        .AllowAnonymous()
        .WithDescription("Check if the server install is ready")
        .Produces<Status>((int)HttpStatusCode.OK);
    }

    public static void MapPerson(this RouteGroupBuilder api)
    {
        var person = api.MapGroup("/person").RequireAuthorization();

        person.MapPost("/", PersonLogic.CreateAsync)
        .AllowAnonymous()
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapGet("/", PersonLogic.GetAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapGet("/caregiver", PersonLogic.GetCaregiverAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        person.MapPost("/role/{personId}", PersonLogic.SetPersonRole)
            .Produces((int)HttpStatusCode.Unauthorized)
            .Produces((int)HttpStatusCode.NoContent);

        var rights = person.MapGroup("/rights");
        rights.MapPost("/{personId}", PersonLogic.SetRight)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapPatients(this RouteGroupBuilder api)
    {
        var patients = api.MapGroup("/patients");
        patients.MapGet("/", PatientsLogic.GetPatientsAsync)
        .Produces<List<Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/agenda", PatientsLogic.GetAgendaAsync)
        .Produces<List<Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        patients.MapGet("/share", PatientsLogic.SharePatient)
       .Produces((int)HttpStatusCode.NoContent)
       .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapMetrics(this RouteGroupBuilder api)
    {
        /* Metrics endpoints*/
        var metrics = api.MapGroup("/metrics").RequireAuthorization();
        metrics.MapGet("/summary", MetricsLogic.GetSummaryAsync)
        .Produces<List<Metric>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapGet("/", MetricsLogic.GetAsync)
        .Produces<List<Metric>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/", MetricsLogic.CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPut("/", MetricsLogic.UpdateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapDelete("/{id}", MetricsLogic.DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        var metricsType = metrics.MapGroup("/type").RequireAuthorization();
        metricsType.MapPost("/", MetricsLogic.CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapPut("/", MetricsLogic.UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapDelete("/{id}", MetricsLogic.DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapGet("/", MetricsLogic.GetTypeAsync)
        .Produces<List<MetricType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);
    }

    public static void MapEvents(this RouteGroupBuilder api)
    {
        /* Events endpoints*/
        var events = api.MapGroup("/events").RequireAuthorization();

        events.MapGet("/summary", EventsLogic.GetSummaryAsync)
        .Produces<EventSummary[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        events.MapGet("/", EventsLogic.GetAsync)
        .Produces<List<Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        events.MapPost("/", EventsLogic.CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        events.MapPut("/", EventsLogic.UpdateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        events.MapDelete("/{id}", EventsLogic.DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        var eventsType = events.MapGroup("/type").RequireAuthorization();
        eventsType.MapPost("/", EventsLogic.CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        eventsType.MapPut("/", EventsLogic.UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        eventsType.MapDelete("/{id}", EventsLogic.DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;

        eventsType.MapGet("/", EventsLogic.GetTypeAsync)
        .Produces<List<Api.Data.Models.EventType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        ;
    }

    public static void MapTreatments(this RouteGroupBuilder api)
    {
        var treatment = api.MapGroup("/treatment").RequireAuthorization();

        treatment.MapPost("/", TreatmentLogic.PostAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        treatment.MapGet("/", TreatmentLogic.GetAsync)
            .Produces<List<Treatment>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        var eventsType = treatment.MapGroup("/type").RequireAuthorization();
        eventsType.MapGet("/", TreatmentLogic.GetTypeAsync)
            .Produces<List<Api.Data.Models.EventType>>((int)HttpStatusCode.OK)
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
    }

    public static void MapEnpoints(this RouteGroupBuilder api)
    {
        api.MapAuth();
        api.MapPerson();
        api.MapPatients();

        api.MapMetrics();
        api.MapEvents();

        api.MapTreatments();

        api.MapAdmin();

        /* Importer endpoint */
        var import = api.MapGroup("/import").RequireAuthorization();
        import.MapGet("/types", ImportLogic.GetImportTypes)
            .Produces<List<FileType>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/{type}", ImportLogic.PostFileAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        import.MapPost("/", ImportLogic.PostListAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);
    }
}