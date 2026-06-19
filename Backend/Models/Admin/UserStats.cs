using Helse.Models.Common;
using Helse.Models.Persons;

namespace Helse.Models.Admin;

public record UserStat(string Name, UserType Type, DateTime Created);

public record UserCreationStats(CountRecord[] UserCount);
