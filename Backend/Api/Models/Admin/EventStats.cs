namespace Api.Models.Admin;

public record EventStats(CountByDate[] Events, Dictionary<string, int> EventCounts);
