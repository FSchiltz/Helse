namespace Helse.Models.Imports;

public record ImportsResult(ImportResult Metrics, ImportResult Events);

public record ImportResult(long Imported, long Skipped, long Failed);
