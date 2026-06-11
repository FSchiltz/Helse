using Api.Models.Common;

namespace Api.Models.Events;

public record EventStats(EventSummary[] Summaries, Interval[] Durations, Event[] Events);

public record EventSummary(Dictionary<string, int> Data);

