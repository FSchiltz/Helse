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
                data[step.Item1].Data[e.Tag ?? string.Empty] += step.Item2;
            }
        }

        return data;
    }

    private static List<(int, int)> Cut(Steps kind, Data.Models.Event e, DateTime start, DateTime end)
    {
        var steps = new List<(int, int)>();

        var endDate = e.Stop.Date.AddDays(1).AddSeconds(-1);

        // add the first step
        steps.Add(GetStep(e.Start, e.Stop, kind));

        return steps;
    }

    private static (int, int) GetStep(DateTime start, DateTime end, Steps kind)
    {
        var startDate = start.Date;
        if (kind == Steps.Hours)
            startDate.AddHours(start.Hour);

        var endDate = Min(end, AddDuration(startDate, kind));
        var startCount = Max(start, startDate);

        int tick;
        int count;
        switch (kind)
        {
            case Steps.Hours:
                count = (int)(endDate - startCount).TotalMinutes;
                tick = 0;
                break;
            default:
                count = 0;
                tick = 0;
                break;

        };

        return (tick, count);
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