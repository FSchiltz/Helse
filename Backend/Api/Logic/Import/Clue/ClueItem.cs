using System.Text.Json.Serialization;

namespace Api.Logic.Import.Clue;

public class ClueItem
{
    public string? Type { get; set; }

    public string? Id { get; set; }

    public string? Date { get; set; }

    [JsonConverter(typeof(SingleOrArrayConverter<Value>))]
    public List<Value>? Value { get; set; }
}
