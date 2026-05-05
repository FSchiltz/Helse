using System.Text.Json.Serialization;

namespace Api.Models.Events;

[JsonConverter(typeof(JsonStringEnumConverter))]
public enum EventTypes
{
    Sleep = 1,
    Care = 2,
    Workout = 3,
}