namespace Api.Models.Settings;

public class UserSettings : IJsonSettings
{
    public static string Name => "User";

    public List<OrderedItem> Metrics { get; set; } = [];

    public List<OrderedItem> Events { get; set; } = [];
}
