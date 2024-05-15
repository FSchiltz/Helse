

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Api.Logic.Import.Clue;

public class ClueItem
{
    public string? Type { get; set; }
    public string? Id { get; set; }
    public string? Date { get; set; }

    [JsonConverter(typeof(SingleOrArrayConverter<Value>))]
    public List<Value>? Value { get; set; }
}

public class Value
{
    public string? Option { get; set; }
}

class SingleOrArrayConverter<T> : JsonConverter
{
    public override bool CanConvert(Type objectType)
    {
        return (objectType == typeof(List<T>));
    }

    public override object ReadJson(JsonReader reader, Type objectType, object? existingValue, JsonSerializer serializer)
    {
        JToken token = JToken.Load(reader);
        if (token.Type == JTokenType.Array)
        {
            return token.ToObject<List<T>>() ?? [];
        }

        var item = token.ToObject<T>();

        if (item is not null)
            return new List<T> { item };
        else
            return new List<T>();
    }

    public override bool CanWrite => false;

    public override void WriteJson(JsonWriter writer, object? value, JsonSerializer serializer) => throw new NotImplementedException();
}