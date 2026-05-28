using System.Text.Json.Serialization;

namespace Api.Models.Persons;

[JsonConverter(typeof(JsonStringEnumConverter))]
public enum RightType
{
    View = 1,
    Edit = 2,
}