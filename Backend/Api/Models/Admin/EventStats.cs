using Api.Models.Common;

namespace Api.Models.Admin;

public record EventsCreationStats(CountByDate[] Events, CountRecord[] EventCounts);
