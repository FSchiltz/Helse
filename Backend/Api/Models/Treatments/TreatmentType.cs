using System.Text.Json.Serialization;

namespace Api.Models.Treatments;

[JsonConverter(typeof(JsonStringEnumConverter))]
public enum TreatmentType
{
    Care,
}
