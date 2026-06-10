namespace Api.Models.Events;

public record EventStats(EventSummary[] Summaries, Duration[] Durations);

public record EventSummary(Dictionary<string, int> Data);

public class Duration
{
    public required DateTime Start { get; set; }

    public required DateTime Stop { get; set; }
}
