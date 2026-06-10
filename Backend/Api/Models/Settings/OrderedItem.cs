namespace Api.Models.Settings;

public class OrderedItem
{
    public bool Visible { get; set; } = true;

    public bool ShowOnDashboard { get; set; } = true;

    public int? Order { get; set; }

    public required string Name { get; set; }

    public required int Id { get; set; }

    public GraphKind Graph { get; set; }

    public GraphKind DetailGraph { get; set; }

    public int? Parent { get; set; }
}