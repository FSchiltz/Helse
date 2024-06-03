using Api.Models;

namespace Api.Helpers;

public static class EventHelpers
{
    private enum Steps
    {
        Hours,
        Days,
        Months,
        Years,
    }

    public static EventSummary[] Summarize(this List<Data.Models.Event> events, DateTime start, DateTime end)
    {
        // first find the number of steps
        var (kind, count) = GetSteps(start, end);

        // create the list of summary
        var data = new EventSummary[count];

        // add each summary in the data
        foreach (var e in events)
        {
            // cut the steps into the different summary          
            // add to the existing summary
            foreach (var step in Cut(kind, e, start, end))
            {
                data[step.Item1] ??= new EventSummary([]);
                var summary = data[step.Item1];
                if (!summary.Data.ContainsKey(e.Description ?? string.Empty))
                {
                    summary.Data[e.Description ?? string.Empty] = step.Item2;
                }
                else
                {
                    summary.Data[e.Description ?? string.Empty] += step.Item2;
                }
            }
        }

        return data;
    }

    private static List<(int, int)> Cut(Steps kind, Data.Models.Event e, DateTime start, DateTime end)
    {
        var steps = new List<(int, int)>();
        var startDate = start;
        int tick = 0;

        do
        {
            var endDate = AddDuration(startDate, kind);

            // First check if the event is inside the current tick
            if (e.Start < endDate && e.Stop > startDate)
            {
                // end and start of the common range between the tick and the event
                var eventEnd = Min(end, endDate);
                var eventStart = Max(start, startDate);

                var count = kind switch
                {
                    Steps.Hours => (int)(eventEnd - eventStart).TotalHours,
                    Steps.Days => (int)(eventEnd - eventStart).TotalDays,
                    Steps.Months => (int)(eventEnd - eventStart).TotalDays / 30,
                    _ => (int)(eventEnd - eventStart).TotalDays / 365,
                };
                steps.Add((tick, count));
            }
            else
            {
                steps.Add((tick, 0));
            }

            startDate = endDate;
            tick++;
        }
        while (startDate < end);

        return steps;
    }

    public static DateTime Min(DateTime date1, DateTime date2) => date1 < date2 ? date1 : date2;
    public static DateTime Max(DateTime date1, DateTime date2) => date1 > date2 ? date1 : date2;

    private static DateTime AddDuration(DateTime date, Steps kind) => kind switch
    {
        Steps.Hours => date.AddHours(1),
        Steps.Days => date.AddDays(1),
        Steps.Months => date.AddMonths(1),
        _ => date.AddYears(1),
    };

    /// <summary>
    /// Find the best steps between two date
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    private static (Steps, int) GetSteps(DateTime start, DateTime end)
    {
        var duration = end - start;
        if (duration.TotalHours <= 24 * 7)
        {
            // less than a week, we can show in hour
            return (Steps.Hours, (int)duration.TotalHours);
        }

        if (duration.TotalDays <= 31 * 3)
        {
            // less than 3 month, show in day
            return (Steps.Days, (int)duration.TotalDays);
        }

        if (duration.TotalDays <= 365 * 3)
        {
            // less than 3 year
            return (Steps.Months, (int)(duration.TotalDays / 31));
        }

        return (Steps.Years, (int)(duration.TotalDays / 365));
    }
}