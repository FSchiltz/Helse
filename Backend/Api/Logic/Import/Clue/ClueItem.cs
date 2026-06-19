using System.Text.Json.Serialization;
using Api.Logic.Import.Clue;

namespace Helse.Api.Logic.Import.Clue;

internal class ClueItem
{
    public string? Type { get; set; }

    public string? Id { get; set; }

    public string? Date { get; set; }

    [JsonConverter(typeof(SingleOrArrayConverter<Value>))]
    public List<Value>? Value { get; set; }
}
