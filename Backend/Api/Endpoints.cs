using System.Net;
using Api.Logic;
using Api.Logic.Auth;
using Api.Models;

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
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        api.MapGet("/status", AuthLogic.StatusAsync)
        .AllowAnonymous()
        .WithDescription("Check if the server install is ready")
        .Produces<Status>((int)HttpStatusCode.OK)
        .WithOpenApi();
    }

    public static void MapPerson(this RouteGroupBuilder api)
    {
        var person = api.MapGroup("/person").RequireAuthorization();

        person.MapPost("/", PersonLogic.CreateAsync)
        .AllowAnonymous()
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        person.MapGet("/", PersonLogic.GetAsync)
        .AllowAnonymous()
        .Produces<List<Api.Models.Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        person.MapPost("/role", PersonLogic.SetPersonRole)
            .Produces((int)HttpStatusCode.Unauthorized)
            .Produces((int)HttpStatusCode.NoContent)
            .WithOpenApi();

        var rights = person.MapGroup("/rights");
        rights.MapPost("/{personId}", PersonLogic.SetRight)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();
    }

    public static void MapPatients(this RouteGroupBuilder api)
    {
        var patients = api.MapGroup("/patients");
        patients.MapGet("/", PatientsLogic.GetPatientsAsync)
        .Produces<List<Api.Models.Person>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        patients.MapGet("/agenda", PatientsLogic.GetAgendaAsync)
        .Produces<List<Api.Models.Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();
    }

    public static void MapMetrics(this RouteGroupBuilder api)
    {
        /* Metrics endpoints*/
        var metrics = api.MapGroup("/metrics").RequireAuthorization();
        metrics.MapGet("/summary", MetricsLogic.GetSummaryAsync)
        .Produces<List<Api.Models.Metric>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metrics.MapGet("/", MetricsLogic.GetAsync)
        .Produces<List<Api.Models.Metric>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metrics.MapPost("/", MetricsLogic.CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metrics.MapDelete("/{id}", MetricsLogic.DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        var metricsType = metrics.MapGroup("/type").RequireAuthorization();
        metricsType.MapPost("/", MetricsLogic.CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metricsType.MapPut("/", MetricsLogic.UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metricsType.MapDelete("/{id}", MetricsLogic.DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        metricsType.MapGet("/", MetricsLogic.GetTypeAsync)
        .Produces<List<Api.Models.MetricType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();
    }

    public static void MapEvents(this RouteGroupBuilder api)
    {
        /* Events endpoints*/
        var events = api.MapGroup("/events").RequireAuthorization();
        events.MapGet("/", EventsLogic.GetAsync)
        .Produces<List<Api.Models.Event>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        events.MapPost("/", EventsLogic.CreateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        events.MapDelete("/{id}", EventsLogic.DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        var eventsType = events.MapGroup("/type").RequireAuthorization();
        eventsType.MapPost("/", EventsLogic.CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        eventsType.MapPut("/", EventsLogic.UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        eventsType.MapDelete("/{id}", EventsLogic.DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();

        eventsType.MapGet("/", EventsLogic.GetTypeAsync)
        .Produces<List<Api.Data.Models.EventType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized)
        .WithOpenApi();
    }

    public static void MapTreatments(this RouteGroupBuilder api)
    {
        var treatment = api.MapGroup("/treatment").RequireAuthorization();

        treatment.MapPost("/", TreatmentLogic.PostAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        treatment.MapGet("/", TreatmentLogic.GetAsync)
            .Produces<List<Api.Models.Treatement>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        var eventsType = treatment.MapGroup("/type").RequireAuthorization();
        eventsType.MapGet("/", TreatmentLogic.GetTypeAsync)
            .Produces<List<Api.Data.Models.EventType>>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();
    }

    public static void MapAdmin(this RouteGroupBuilder api)
    {
        var admin = api.MapGroup("/admin").RequireAuthorization();

        var settings = admin.MapGroup("/settings").RequireAuthorization();
        settings.MapPost("/oauth", SettingsLogic.PostOauthAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        settings.MapGet("/oauth", SettingsLogic.GetOauthAsync)
            .Produces<Oauth>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        settings.MapPost("/proxy", SettingsLogic.PostProxyAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        settings.MapGet("/proxy", SettingsLogic.GetProxyAsync)
            .Produces<Proxy>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();
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
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        import.MapPost("/{type}", ImportLogic.PostFileAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();

        import.MapPost("/", ImportLogic.PostListAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized)
            .WithOpenApi();
    }
}