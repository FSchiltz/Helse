using Helse.Models.Events;
using Helse.Models.Metrics;

namespace Helse.Models.Imports;

public class ImportData
{
    public List<CreateMetric> Metrics { get; set; } = [];

    public List<CreateEvent> Events { get; set; } = [];
}
