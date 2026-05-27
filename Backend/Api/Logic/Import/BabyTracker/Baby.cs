namespace Api.Logic.Import.BabyTracker;

public class Baby
{
    public string? Birthday { get; set; }

    public string? Gender { get; set; }

    public string? Name { get; set; }
    
    public List<Record> Records { get; set; } = [];
}
