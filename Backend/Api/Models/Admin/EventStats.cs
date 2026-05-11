namespace Api.Models.Admin;

public record EventStats(CountByDate[] Events, CountRecord[] EventCounts);
