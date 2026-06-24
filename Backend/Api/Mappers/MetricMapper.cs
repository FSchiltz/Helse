using Helse.Api.Data.Models.Health;
using Helse.Models.Imports;

namespace Helse.Api.Mappers;

internal static class MetricMapper
{
    internal static Helse.Models.Metrics.Metric Map(Metric x)
    {
        return new Helse.Models.Metrics.Metric()
        {
            Value = x.Value,
            Date = x.Date,
            Id = x.Id,
            Person = x.PersonId,
            SourceId = x.SourceId,
            Type = x.Type,
            Source = (FileTypes)x.Source,
            Tag = x.Tag,
            Unit = x.UnitObject.ToUnit(),
        };
    }
}
