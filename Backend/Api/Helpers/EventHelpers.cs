using Helse.Models.Common;
using Helse.Models.Events;

namespace Helse.Api.Helpers;

internal static class EventHelpers
{
    public static EventStats Summarize(this Data.Models.Health.Event[] events, DateTime start, DateTime end)
    {
        // first find the number of steps
        var (bucketCount, secondPerBucket) = GetSteps(start, end);

        if (events.Length <= bucketCount && events.Length > 0)
        {
            List<Interval> durations = [];
            foreach (var e in events)
            {
                AddToDuration(e.Start, e.Stop, durations);
            }

            return new([], [.. durations], [.. events.Select(x => new Models.Events.Event
            {
                Id = x.Id,
                Type = x.Type,
                Description = x.Description,
                Stop = DateTime.SpecifyKind(x.Stop, DateTimeKind.Utc),
                Start = DateTime.SpecifyKind(x.Start, DateTimeKind.Utc),
            })]);
        }
        else
        {
            // create the list of summary
            var data = new EventSummary[bucketCount];
            for (int i = 0; i < data.Length; i++)
            {
                data[i] = new EventSummary([]);
            }

            List<Interval> durations = [];

            // add each summary in the data
            foreach (var e in events)
            {
                AddToDuration(e.Start, e.Stop, durations);

                // cut the steps into the different summary    
                var steps = Cut(secondPerBucket, e, start, end);

                // add to the existing summary
                foreach (var step in steps)
                {
                    if (step.Item1 > bucketCount)
                        throw new InvalidDataException("Date mismatched");

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

            return new(data, [.. durations], []);
        }
    }

    private static void AddToDuration(DateTime start, DateTime stop, List<Interval> durations)
    {
        var duration = durations.FirstOrDefault(x => stop.AddSeconds(10) >= x.Start && start.AddSeconds(-10) <= x.Stop);
        if (duration is null)
        {
            durations.Add(new()
            {
                Start = start,
                Stop = stop,
            });
        }
        else
        {
            if (start < duration.Start)
            {
                // the event is before, we add to the start
                duration.Start = start;
            }

            if (stop > duration.Stop)
            {
                // the event is after
                duration.Stop = stop;
            }
        }
    }

    private static List<(int, int)> Cut(double secondPerBucket, Data.Models.Health.Event e, DateTime start, DateTime end)
    {
        var steps = new List<(int, int)>();
        var startDate = start;
        int tick = 0;

        do
        {
            var endDate = startDate.AddSeconds(secondPerBucket);

            // First check if the event is inside the current tick
            if (e.Start < endDate && e.Stop > startDate)
            {
                // end and start of the common range between the tick and the event
                var eventEnd = Min(end, endDate);
                var eventStart = Max(start, startDate);
                var count = (int)((eventEnd - eventStart).TotalSeconds / secondPerBucket);

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

    /// <summary>
    /// Find the best steps between two date
    /// </summary>
    /// <param name="start"></param>
    /// <param name="end"></param>
    /// <returns></returns>
    private static (int BucketCount, double SecondPerBucket) GetSteps(DateTime start, DateTime end)
    {
        const int maxBucket = 200;
        var duration = end - start;
        if (duration.TotalSeconds <= maxBucket)
        {
            return ((int)duration.TotalSeconds, 1);
        }

        return (maxBucket, duration.TotalSeconds / maxBucket);
    }
}
