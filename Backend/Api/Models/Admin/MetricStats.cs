namespace Api.Models.Admin;

public record MetricStats(CountByDate[] Events, CountRecord[] EventCounts);