namespace Api.Models.Settings;

public class UserSettings : IJsonSettings
{
    public static string Name => "User";

    public DatePreset DatePreset { get; set; }

    public Theme Theme { get; set; }

    public int EventWidth { get; set; }

    public List<OrderedItem> Metrics { get; set; } = [];

    public List<OrderedItem> MetricGroups { get; set; } = [];

    public List<OrderedItem> Events { get; set; } = [];
}
