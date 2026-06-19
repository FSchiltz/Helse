using Helse.Models.Common;

namespace Helse.Models.Admin;

public record MetricCreationStats(CountByDate[] Events, CountRecord[] EventCounts);