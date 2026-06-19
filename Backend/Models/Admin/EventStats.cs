using Helse.Models.Common;

namespace Helse.Models.Admin;

public record EventCreationStats(CountByDate[] Events, CountRecord[] EventCounts);
