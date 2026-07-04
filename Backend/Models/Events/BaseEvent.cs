using Helse.Models.Imports;

namespace Helse.Models.Events;

public abstract class BaseEvent
{
    public required int Type { get; set; }

    public string? Description { get; set; }

    public required DateTime Start { get; set; }

    public required DateTime Stop { get; set; }

    public string? Tag { get; set; }

    public DateTime? NotificationTime { get; set; }

    public ImportTypes Source { get; set; }

    public string SourceId { get; set; } = string.Empty;
}
