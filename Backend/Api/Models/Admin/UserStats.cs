using Api.Data.Models.Persons;

namespace Api.Models.Admin;

public record UserStat(string Name,UserType Type, DateTime Created);

public record UserStats(CountRecord[] UserCount);
