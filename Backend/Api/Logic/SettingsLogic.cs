using System.Text.Json;
using Helse.Api.Data;
using Helse.Api.Data.Models.Health;
using Helse.Api.Helpers;
using Helse.Models.Settings;
using Helse.Models.Settings.Admin;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Helse.Api.Logic;

/// <summary>
/// Management of the server settings
/// </summary>
internal static class SettingsLogic
{
    public static async Task<IResult> GetUserSettings(IUserContext users, ISettingsContext settings, IMetricContext metrics, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        var data = await settings.GetSettings<UserSettings>(UserSettings.Name, user.Id);
        await Upgrade(data, events, metrics);
        return error ?? TypedResults.Ok(data);
    }

    /// <summary>
    /// Update the user settings
    /// </summary>
    /// <param name="settings"></param>
    /// <param name="users"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public static async Task<IResult> PostUserSettingsAsync(UserSettings settings, IUserContext users, ISettingsContext db, HttpContext context, ILoggerFactory logger)
    {
        var log = logger.CreateLogger(nameof(SettingsLogic));

        var (error, user) = await users.GetUser(context.User);
        return error ?? await db.Save(settings, user.Id, log);
    }

    public static async Task<IResult> GetPatientsSettings(IUserContext users, ISettingsContext settings, IMetricContext metrics, IEventContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        var data = await settings.GetSettings<PatientsSettings>(PatientsSettings.Name, user.Id);
        await Upgrade(data, metrics, events);
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

    private static async Task<Created> Save<T>(this ISettingsContext db, T settings, ILogger log)
    where T : IJsonSettings
    {
        var data = JsonSerializer.Serialize(settings);
        await db.Upsert(T.Name, data);

        log.LogInformation("Settings saved");
        return TypedResults.Created();
    }

    private static async Task<Created> Save<T>(this ISettingsContext db, T settings, long user, ILogger log) where T : IJsonSettings
    {
        var data = JsonSerializer.Serialize(settings);
        await db.Upsert(T.Name, user, data);

        log.LogInformation("Settings saved");
        return TypedResults.Created();
    }

    private static async Task Upgrade(PatientsSettings data, IMetricContext metrics, IEventContext events)
    {
        if (data.Version < 2)
        {
            data.Version = 2;
            UpgradeV2(data.Default);
            foreach (var patient in data.Patients)
            {
                UpgradeV2(patient);
            }
        }

        if (data.Version < 3)
        {
            data.Version = 3;
            UpgradeV3(data.Default);
            foreach (var patient in data.Patients)
            {
                UpgradeV3(patient);
            }
        }

        // update the metrics 
        var metricTypes = await metrics.GetMetricTypes(false, null);
        data.Default.MetricSettings.DisplaySettings = UpdateMetrics(data.Default.MetricSettings.DisplaySettings, metricTypes);

        // update the events
        var eventTypes = await events.GetEventTypes(false);
        data.Default.EventSettings.DisplaySettings = UpdateEvents(data.Default.EventSettings.DisplaySettings, eventTypes);

        var metricGroups = await metrics.GetMetricGroups();
        data.Default.Groups.DisplaySettings = UpdateMetricGroups(data.Default.Groups.DisplaySettings, metricGroups);

        foreach (var patient in data.Patients)
        {
            patient.MetricSettings.DisplaySettings = UpdateMetrics(patient.MetricSettings.DisplaySettings, metricTypes);
            patient.EventSettings.DisplaySettings = UpdateEvents(patient.EventSettings.DisplaySettings, eventTypes);
            patient.Groups.DisplaySettings = UpdateMetricGroups(patient.Groups.DisplaySettings, metricGroups);
        }
    }

    private static async Task Upgrade(UserSettings data, IEventContext events, IMetricContext metrics)
    {
        if (data.Version < 2)
        {
            UpgradeV2(data);
        }

        if (data.Version < 3)
        {
            UpgradeV3(data);
        }

        // update the metrics 
        var metricTypes = await metrics.GetMetricTypes(false, null);
        data.MetricSettings.DisplaySettings = UpdateMetrics(data.MetricSettings.DisplaySettings, metricTypes);

        var metricGroups = await metrics.GetMetricGroups();
        data.Groups.DisplaySettings = UpdateMetricGroups(data.Groups.DisplaySettings, metricGroups);

        // update the events
        var eventTypes = await events.GetEventTypes(false);
        data.EventSettings.DisplaySettings = UpdateEvents(data.EventSettings.DisplaySettings, eventTypes);
    }

    private static List<OrderedItem> UpdateMetricGroups(List<OrderedItem> data, MetricGroup[] metricGroups)
    {
        List<OrderedItem> newList = [];
        foreach (var e in metricGroups)
        {
            var existing = data.FirstOrDefault((element) => element.Id == e.Id);
            if (existing != null)
            {
                existing.Name = existing.Name;
                newList.Add(existing);
            }
            else
            {
                newList.Add(
                    new OrderedItem()
                    {
                        Id = e.Id,
                        Name = e.Name,
                        Graph = GraphKind.Text,
                        DetailGraph = GraphKind.Text,
                        Visible = e.ShowOnDashboard,
                        ShowOnDashboard = true,
                    });
            }
        }

        return newList;
    }

    private static List<OrderedItem> UpdateEvents(List<OrderedItem> data, Data.Models.Health.EventType[] eventTypes)
    {
        List<OrderedItem> newList = [];
        foreach (var e in eventTypes)
        {
            var existing = data.FirstOrDefault((element) => element.Id == e.Id);
            if (existing != null)
            {
                existing.Name = existing.Name;
                newList.Add(existing);
            }
            else
            {
                newList.Add(
                    new OrderedItem()
                    {
                        Id = e.Id,
                        Name = e.Name,
                        Graph = GraphKind.Text,
                        DetailGraph = GraphKind.Text,
                        Visible = e.Visible,
                        ShowOnDashboard = true,
                    });
            }
        }
        return newList;
    }

    private static void UpgradeV3(UserSettings data)
    {
        data.Version = 3;
        data.Groups = data.MetricSettings.Groups;
        data.MetricSettings.Groups = null;
    }

    private static void UpgradeV2(UserSettings data)
    {
        // version 2 upgrade
        data.Version = 2;
        data.EventSettings = new EventSettings()
        {
            DisplaySettings = data.Events,
            DisplayValueSettings = [],
        };
        data.MetricSettings = new MetricSettings()
        {
            DisplaySettings = data.Metrics,
            Groups = new MetricGroupSettings()
            {
                DisplaySettings = data.MetricGroups,
            },
        };

        data.Events = [];
        data.MetricGroups = [];
        data.Metrics = [];
    }

    private static OrderedItem GetDefault(MetricType item)
    {
        if (item.Type == (long)Models.Metrics.MetricDataType.Number)
        {
            return new OrderedItem()
            {
                Id = item.Id,
                Name = item.Name,
                Graph = GraphKind.Bar,
                DetailGraph = GraphKind.Line,
                Visible = item.Visible,
                ShowOnDashboard = true,
                Parent = item.GroupId,
            };
        }

        return new OrderedItem()
        {
            Id = item.Id,
            Name = item.Name,
            Graph = GraphKind.Text,
            DetailGraph = GraphKind.Text,
            Visible = item.Visible,
            ShowOnDashboard = true,
            Parent = item.GroupId,
        };
    }

    private static List<OrderedItem> UpdateMetrics(List<OrderedItem> data, MetricType[] metricTypes)
    {
        List<OrderedItem> newList = [];
        foreach (var metric in metricTypes)
        {
            var existing = data.FirstOrDefault((element) => element.Id == metric.Id);
            if (existing != null)
            {
                existing.Name = existing.Name;
                newList.Add(existing);
            }
            else
            {
                newList.Add(GetDefault(metric));
            }
        }

        return newList;
    }
}
