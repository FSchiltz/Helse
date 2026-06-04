using System.IO.Compression;
using System.Text.Json;
using Api.Data;
using Api.Jobs;
using Api.Models.Events;
using Api.Models.Imports;
using Api.Models.Metrics;
using CsvHelper;

namespace Api.Logic.Import.BabyTracker;

public class BabyTrackerImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    private readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true,
    };

    public override async Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        await using var zip = new ZipArchive(File);

        long metricAdds = 0;
        long metricSkips = 0;
        long eventAdds = 0;
        long eventSkips = 0;
        foreach (var file in zip.Entries)
        {
            queue.Progress(id, 0);
            await using var stream = await file.OpenAsync();

            var json = await JsonSerializer.DeserializeAsync<Baby>(stream, _options);
            if (json == null)
            {
                continue;
            }

            int count = 0;
            foreach (var item in json.Records)
            {
                CreateEvent? createEvent = null;
                CreateMetric? createMetric = null;
                switch (item.Type.ToUpper())
                {
                    case "HEALTH":
                        createMetric = ImportHealth(item);
                        break;
                    case "PUMP":
                    case "FEEDING":
                        createEvent = ImportPump(item);
                        break;
                    case "GROWTH":
                        createMetric = ImportGrowth(item);
                        break;
                    case "SLEEPING":
                        createEvent = ImportSleep(item);
                        break;
                    case "LEISURE":
                        createEvent = ImportLeisure(item);
                        break;
                    case "DIAPERING":
                        createMetric = ImportDiaper(item);
                        break;
                    default:
                        throw new NotSupportedException();
                }

                if (createEvent is not null)
                {
                    var added = await ImportEvent(createEvent);
                    if (added)
                    {
                        eventAdds++;
                    }
                    else
                    {
                        eventSkips++;
                    }
                }

                if (createMetric is not null)
                {
                    var added = await ImportMetric(createMetric);
                    if (added)
                    {
                        metricAdds++;
                    }
                    else
                    {
                        metricSkips++;
                    }
                }
                count++;
                queue.Progress(id, count / (double)json.Records.Count);
            }
        }

        return new(new(metricAdds, metricSkips, 0), new(eventAdds, eventSkips, 0));
    }

    private static CreateMetric ImportDiaper(Record item)
    {
        return new CreateMetric()
        {
            Value = item.Amount.ToString(),
            Date = ToDate(item.FromDate),
            Source = FileTypes.BabyTracker,
            Type = (long)MetricTypes.Diaper,
            SourceId = GetKey(item),
        };
    }

    private static string GetKey(Record item) => $"{item.FromDate}_{item.ToDate}_{item.Subtype}";

    private static CreateEvent ImportLeisure(Record item)
    {
        switch (item.Subtype)
        {
            case "LEISURE_BATH":
                return new CreateEvent()
                {
                    Start = ToDate(item.FromDate),
                    Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
                    Description = string.Empty,
                    Tag = item.Details,
                    Type = (int)EventTypes.Bath,
                    Source = FileTypes.BabyTracker,
                    SourceId = GetKey(item),
                };
            default:
                throw new NotSupportedException();

        }
    }

    private static CreateEvent ImportSleep(Record item)
    {
        return new CreateEvent()
        {
            Start = ToDate(item.FromDate),
            Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
            Description = string.Empty,
            Tag = item.Details,
            Type = (int)EventTypes.Sleep,
            Source = FileTypes.BabyTracker,
            SourceId = GetKey(item),
        };
    }

    private static CreateMetric ImportGrowth(Record item)
    {
        var type = item.Subtype switch
        {
            "GROWTH_HEAD" => (long)MetricTypes.HeadDiameter,
            "GROWTH_HEIGHT" => (long)MetricTypes.Height,
            "GROWTH_WEIGHT" => (long)MetricTypes.Wheight,
            _ => throw new NotSupportedException(),
        };
        return new CreateMetric()
        {
            Value = item.Amount.ToString(),
            Date = ToDate(item.FromDate),
            Source = FileTypes.BabyTracker,
            Type = type,
            SourceId = GetKey(item),
        };
    }

    private static CreateEvent ImportPump(Record item)
    {
        string description = item.Subtype.ToUpper() switch
        {
            "PUMP_LEFT" => "Pump Left",
            "PUMP_RIGHT" => "Pump Right",
            "PUMP_BOTH" => "Pump Both",
            "LEFT_BREAST" => "Left breast",
            "RIGHT_BREAST" => "Right breast",
            "BOTTLE" => "Bottle",
            _ => item.Subtype,
        };
        return new CreateEvent()
        {
            Start = ToDate(item.FromDate),
            Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
            Description = description,
            Tag = $"{item.Amount}{GetUnit(item.Unit)} {item.Details}",
            Type = (int)EventTypes.Feeding,
            Source = FileTypes.BabyTracker,
            SourceId = GetKey(item),
        };
    }

    private static string GetUnit(string unit)
    {
        return unit.ToUpper() switch
        {
            "NONE" => string.Empty,
            "MILLIMETERS" => "mm",
            "MILLILITRES" => "mL",
            _ => throw new NotSupportedException(),
        };
    }

    private static DateTime ToDate(string date) => DateTime.Parse(date);

    private static CreateMetric ImportHealth(Record item)
    {
        switch (item.Subtype.ToUpper())
        {
            case "HEALTH_VACCINATIONS":
                return new CreateMetric()
                {
                    Value = "Vaccination: " + item.Details,
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Medication,
                    SourceId = GetKey(item),
                };
            case "HEALTH_MEDICATIONS":
                return new CreateMetric()
                {
                    Value = item.Details,
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Medication,
                    SourceId = GetKey(item),
                };
            case "HEALTH_TEMPERATURE":
                return new CreateMetric()
                {
                    Value = item.Amount.ToString(),
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Temperature,
                    SourceId = GetKey(item),
                };
            default:
                throw new NotSupportedException();
        }
    }
}
