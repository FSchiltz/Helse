using Helse.Models.Imports;

namespace Helse.Models.Events;

public class SearchEvent
{
    public required long Type { get; set; }

    /// <summary>
    /// Search by text inside the values
    /// </summary>
    public string? Value { get; set; }

    public DateTime? From { get; set; }

    public DateTime? To { get; set; }

    public ImportTypes Source { get; set; }

    /// <summary>
    /// We have to do this because flutter don't like nullable enum
    /// </summary>
    public bool FilterSource { get; set; }
}