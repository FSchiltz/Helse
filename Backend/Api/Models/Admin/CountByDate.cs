namespace Api.Models.Admin;

public record CountByDate(DateTime Date, int Count);

public record CountRecord(string Id, int Count);