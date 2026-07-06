using System.Net;
using Helse.Api.Data;
using Helse.Api.Helpers;
using Helse.Models.Admin;
using Helse.Models.Common;
using Helse.Models.Settings.Admin;

namespace Helse.Api.Logic;

internal static class AdminLogic
{
    public static RouteGroupBuilder MapAdmin(this RouteGroupBuilder api)
    {
        var admin = api.MapGroup("/admin").RequireAuthorization();

        var settings = admin.MapGroup("/settings").RequireAuthorization();
        settings.MapPost("/oauth", PostOauthAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/oauth", GetOauthAsync)
            .Produces<Oauth>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/proxy", PostProxyAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/proxy", GetProxyAsync)
            .Produces<Proxy>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/smtp", PostSmtpAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/gotify", GetGotifyAsync)
            .Produces<Gotify>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapPost("/gotify", PostGotifyAsync)
            .Produces((int)HttpStatusCode.NoContent)
            .Produces((int)HttpStatusCode.Unauthorized);

        settings.MapGet("/smtp", GetSmtpAsync)
            .Produces<Smtp>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        var stats = admin.MapGroup("/stats").RequireAuthorization();
        stats.MapGet("/users", GetUserStatsAsync)
            .Produces<UserCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        stats.MapGet("/events", GetEventStatsAsync)
            .Produces<EventCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        stats.MapGet("/metrics", GetMetricStatsAsync)
            .Produces<MetricCreationStats>((int)HttpStatusCode.OK)
            .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    /// <summary>
    /// Get the Oauth settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetOauthAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Oauth>(Oauth.Name));
    }

    /// <summary>
    /// Get the proxy auth settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetProxyAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Proxy>(Proxy.Name));
    }

    /// <summary>
    /// Update the Oauth settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostOauthAsync(Oauth settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Update the auth proxy settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostProxyAsync(Proxy settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Get the smtp settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetSmtpAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Smtp>(Smtp.Name));
    }

    /// <summary>
    /// Update the smtp settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostSmtpAsync(Smtp settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    /// <summary>
    /// Get the gotify settings
    /// </summary>
    /// <param name="users">The user context</param>
    /// <param name="context">The settings context</param>
    /// <returns>The settings</returns>
    public static async Task<IResult> GetGotifyAsync(IUserContext users, ISettingsContext settings, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        return admin ?? TypedResults.Ok(await settings.GetSettings<Gotify>(Gotify.Name));
    }

    /// <summary>
    /// Update the gotify settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostGotifyAsync(Gotify settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));
        var admin = await users.IsAdmin(context.User);
        return admin ?? await db.Save(settings, log);
    }

    public async static Task<IResult> GetUserStatsAsync(IUserContext users, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var allUsers = await stats.GetUserSumary();

        return TypedResults.Ok(new UserCreationStats(allUsers));
    }


    public async static Task<IResult> GetMetricStatsAsync(DateTime start, DateTime end, IUserContext users, IMetricContext health, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        // Get all events in the date range
        var events = await stats.GetMetricStats(start, end);

        var counts = await stats.CountMetricsByType(start, end);
        var types = await health.GetMetricTypes(true, null);
        var countWithDescription = counts
            .Select(x => new CountRecord(types.First(t => t.Id == x.Key).Name, x.Value))
            .ToArray();

        return TypedResults.Ok(new MetricCreationStats(events, countWithDescription));
    }

    public async static Task<IResult> GetEventStatsAsync(DateTime start, DateTime end, IUserContext users, IEventContext health, IStatsContext stats, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        // Get all events in the date range
        var events = await stats.GetEventStats(start, end);

        var counts = await stats.CountEventsByType(start, end);
        var eventTypes = await health.GetEventTypes(true);
        var countWithDescription = counts
            .Select(x => new CountRecord(eventTypes.First(t => t.Id == x.Key).Name, x.Value))
            .ToArray();

        return TypedResults.Ok(new EventCreationStats(events, countWithDescription));
    }
}