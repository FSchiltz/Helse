namespace Api.Models.Settings;

public class UserSettings : IJsonSettings
{
    public static string Name => "User";

    public DatePreset DatePreset { get; set; }

    public InterfaceTheme Theme { get; set; }

    public int EventWidth { get; set; }

    public List<OrderedItem> Metrics { get; set; } = [];

    public List<OrderedItem> MetricGroups { get; set; } = [];

    public List<OrderedItem> Events { get; set; } = [];

    public List<ColorValue> Colors { get; set; } = [];
}

public record ColorValue(string Key, StateType Type, long Value);

public enum StateType
{
    events = 0,
    eventsValue = 1,
    metrics = 2,
    metricsGroup = 3,
    metricsValue = 4
}