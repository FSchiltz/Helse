namespace Api.Models.Admin;

public record UserStats(int TotalUsers, Dictionary<string, int> UserCount);
