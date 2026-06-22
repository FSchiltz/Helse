namespace Helse.Models.Metrics;

public class UpdateGroup : CreateGroup
{
    public long Id { get; set; }
}

public class CreateGroup : BaseGroup
{
}

public class Group : BaseGroup
{
    public long Id { get; set; }
}

public abstract class BaseGroup
{
    public required string Name { get; set; }

    public required string Description { get; set; }

    public bool ShowOnDashboard { get; set; }

    public bool ShowTitle { get; set; }
}
