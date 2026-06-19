namespace Helse.Models.Settings;

public class OrderedItem
{
    public bool? Visible { get; set; } = true;

    public bool? ShowOnDashboard { get; set; } = true;

    public int? Order { get; set; }

    public required string Name { get; set; }

    public required long Id { get; set; }

    public string? Key { get; set; }

    public GraphKind Graph { get; set; } = GraphKind.Text;

    public GraphKind DetailGraph { get; set; } = GraphKind.Text;

    public long? Parent { get; set; }

    public long? Color { get; set; }
}