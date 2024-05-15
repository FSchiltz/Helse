

namespace Api.Logic.Import.Clue;

public class ClueItem
{
    public string? Type { get; set; }
    public string? Id { get; set; }
    public string? Date { get; set; }
    public List<Value>? Value { get; set; }
}

public class Value
{
    public string? Option { get; set; }
}