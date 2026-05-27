using System.Text.Json;
using System.Text.Json.Serialization;

namespace Api.Logic.Import.Clue;

internal class SingleOrArrayConverter<T> : JsonConverter<List<T>>
{
    public override List<T>? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        List<T> items = [];

        if (reader.TokenType == JsonTokenType.StartArray)
        {
            while (reader.Read())
            {
                if (reader.TokenType == JsonTokenType.EndArray)
                {
                    break;
                }

                var item = JsonSerializer.Deserialize<T>(ref reader, options);
                if (item is not null)
                {
                    items.Add(item);
                }
            }
        }
        else if(reader.TokenType == JsonTokenType.StartObject)
        {
            var item = JsonSerializer.Deserialize<T>(ref reader, options);
            if (item is not null)
            {
                items.Add(item);
            }
        }
        else
        {
            throw new JsonException();
        }

        return items;
    }

    public override void Write(Utf8JsonWriter writer, List<T> value, JsonSerializerOptions options) => throw new NotImplementedException();
}