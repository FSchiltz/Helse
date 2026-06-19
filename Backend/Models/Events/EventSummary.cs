using Helse.Models.Common;

namespace Helse.Models.Events;

public record EventStats(EventSummary[] Summaries, Interval[] Durations, Event[] Events);

public record EventSummary(Dictionary<string, int> Data);

