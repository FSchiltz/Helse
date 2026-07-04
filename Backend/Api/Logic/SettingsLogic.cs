using System.Text.Json;
using Helse.Api.Data;
using Helse.Api.Data.Models.Health;
using Helse.Models.Settings;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Helse.Api.Logic;

/// <summary>
/// Management of the server settings
/// </summary>
internal static class SettingsLogic
{
    public static async Task<Created> Save<T>(this ISettingsContext db, T settings, ILogger log)
    where T : IJsonSettings
    {
        var data = JsonSerializer.Serialize(settings);
        await db.Upsert(T.Name, data);

        log.LogInformation("Settings saved");
        return TypedResults.Created();
    }
    
    public static async Task<Created> Save<T>(this ISettingsContext db, T settings, long user, ILogger log) where T : IJsonSettings
    {
        var data = JsonSerializer.Serialize(settings);
        await db.Upsert(T.Name, user, data);

        log.LogInformation("Settings saved");
        return TypedResults.Created();
    }

    public static async Task Upgrade(PatientsSettings data, IMetricContext metrics, IEventContext events)
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

    public static async Task Upgrade(UserSettings data, IEventContext events, IMetricContext metrics)
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
                existing.Name = e.Name;
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
                existing.Name = e.Name;
                existing.Parent = e.GroupId;
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
                        Parent = e.GroupId,
                    });
            }
        }
        return newList;
    }

    private static void UpgradeV3(UserSettings data)
    {
        data.Version = 3;
        data.Groups = data.MetricSettings.Groups ?? new()
        {
            DisplaySettings = [],
        };
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
                existing.Name = metric.Name;
                existing.Parent = metric.GroupId;
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
