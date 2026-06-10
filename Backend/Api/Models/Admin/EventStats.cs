using Api.Models.Common;

namespace Api.Models.Admin;

public record EventCreationStats(CountByDate[] Events, CountRecord[] EventCounts);
