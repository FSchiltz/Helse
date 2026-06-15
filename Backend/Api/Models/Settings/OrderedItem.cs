namespace Api.Models.Settings;

public class OrderedItem
{
    public bool Visible { get; set; } = true;

    public bool ShowOnDashboard { get; set; } = true;

    public int? Order { get; set; }

    public required string Name { get; set; }

    public required long Id { get; set; }

    public string? Key { get; set; }

    public GraphKind Graph { get; set; }

    public GraphKind DetailGraph { get; set; }

    public long? Parent { get; set; }

    public long Color { get; set; }
}