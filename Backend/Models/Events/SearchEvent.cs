using Helse.Models.Common;

namespace Helse.Models.Events;

public class SearchEvent : Pagination
{
    public required long Type { get; set; }

    /// <summary>
    /// Search by text inside the values
    /// </summary>
    public string? Value { get; set; }

    public DateTime? From { get; set; }

    public DateTime? To { get; set; }
}