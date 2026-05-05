using System.Text.Json.Serialization;

namespace Api.Models.Metrics;

[JsonConverter(typeof(JsonStringEnumConverter))]
public enum MetricDataType
{
    Text,
    Number,
}
