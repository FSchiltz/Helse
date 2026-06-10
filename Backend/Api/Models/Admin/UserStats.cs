using Api.Data.Models.Persons;
using Api.Models.Common;

namespace Api.Models.Admin;

public record UserStat(string Name,UserType Type, DateTime Created);

public record UserCreationStats(CountRecord[] UserCount);
