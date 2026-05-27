namespace Api.Logic.Import.BabyTracker;

public class Record
{
    public double Amount { get; set; }
    public required string Category { get; set; }
    public required string Details { get; set; }
    public required string FromDate { get; set; }
    public required string Subtype { get; set; }
    public required string Type { get; set; }
    public required string Unit { get; set; }
}
