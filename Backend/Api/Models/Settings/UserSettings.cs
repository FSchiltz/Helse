using Microsoft.Extensions.Logging.EventLog;

namespace Api.Models.Settings;

public class EventSettings
{
    public List<OrderedItem> DisplaySettings { get; set; } = [];

    public List<OrderedItem> DisplayValueSettings { get; set; } = [];
}

public class MetricSettings
{
    public List<OrderedItem> DisplaySettings { get; set; } = [];

    public MetricGroupSettings? Groups { get; set; }
}

public class MetricGroupSettings
{
    public List<OrderedItem> DisplaySettings { get; set; } = [];
}

public class UserSettings : IJsonSettings
{
    public int Version { get; set; }  = 1;

    public static string Name => "User";

    public DatePreset DatePreset { get; set; } = DatePreset.Today;

    public InterfaceTheme Theme { get; set; } = InterfaceTheme.System;

    public int EventWidth { get; set; }

    [Obsolete]
    public List<OrderedItem> Metrics { get; set; } = [];

    [Obsolete]
    public List<OrderedItem> MetricGroups { get; set; } = [];

    [Obsolete]
    public List<OrderedItem> Events { get; set; } = [];

    public EventSettings? EventSettings { get; set; }

    public MetricSettings? MetricSettings { get; set; }
}

public enum StateType
{
    events = 0,
    eventsValue = 1,
    metrics = 2,
    metricsGroup = 3,
    metricsValue = 4
}