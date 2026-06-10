using Api.Models.Common;

namespace Api.Models.Admin;

public record MetricCreationStats(CountByDate[] Events, CountRecord[] EventCounts);