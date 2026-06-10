using Api.Models.Common;

namespace Api.Models.Events;

public record EventStats(EventSummary[] Summaries, Interval[] Durations);

public record EventSummary(Dictionary<string, int> Data);

