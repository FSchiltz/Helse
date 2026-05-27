using System.IO.Compression;
using System.Text.Json;
using Api.Data;
using Api.Jobs;
using Api.Models;
using Api.Models.Events;
using Api.Models.Metrics;
using CsvHelper;

namespace Api.Logic.Import.BabyTracker;

public class BabyTrackerImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    private readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true,
    };

    public override async Task Import(IImportQueue queue, Guid id)
    {
        await using var zip = new ZipArchive(File);
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
                switch (item.Type.ToUpper())
                {
                    case "HEALTH":
                        await ImportHealth(item);
                        break;
                    case "PUMP":
                    case "FEEDING":
                        await ImportPump(item);
                        break;
                    case "GROWTH":
                        await ImportGrowth(item);
                        break;
                    case "SLEEPING":
                        await ImportSleep(item);
                        break;
                    case "LEISURE":
                        await ImportLeisure(item);
                        break;
                    case "DIAPERING":
                        await ImportDiaper(item);
                        break;
                    default:
                        throw new NotSupportedException();
                }
                count++;
                queue.Progress(id, count / (double)json.Records.Count);
            }
        }
    }

    private async Task ImportDiaper(Record item)
    {
        await ImportMetric(new CreateMetric()
        {
            Value = item.Amount.ToString(),
            Date = ToDate(item.FromDate),
            Source = FileTypes.BabyTracker,
            Type = (long)MetricTypes.Diaper,
        });
    }

    private async Task ImportLeisure(Record item)
    {
        switch (item.Subtype)
        {
            case "LEISURE_BATH":
                await ImportEvent(new CreateEvent()
                {
                    Start = ToDate(item.FromDate),
                    Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
                    Description = string.Empty,
                    Tag = item.Details,
                    Type = (int)EventTypes.Bath,
                    Source = FileTypes.BabyTracker,
                });
                break;
            default:
                throw new NotSupportedException();

        }
    }

    private async Task ImportSleep(Record item)
    {
        await ImportEvent(new CreateEvent()
        {
            Start = ToDate(item.FromDate),
            Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
            Description = string.Empty,
            Tag = item.Details,
            Type = (int)EventTypes.Sleep,
            Source = FileTypes.BabyTracker,
        });
    }

    private async Task ImportGrowth(Record item)
    {
        var type = item.Subtype switch
        {
            "GROWTH_HEAD" => (long)MetricTypes.HeadDiameter,
            "GROWTH_HEIGHT" => (long)MetricTypes.Height,
            "GROWTH_WEIGHT" => (long)MetricTypes.Wheight,
            _ => throw new NotSupportedException(),
        };
        await ImportMetric(new CreateMetric()
        {
            Value = item.Amount.ToString(),
            Date = ToDate(item.FromDate),
            Source = FileTypes.BabyTracker,
            Type = type,
        });
    }

    private async Task ImportPump(Record item)
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
        await ImportEvent(new CreateEvent()
        {
            Start = ToDate(item.FromDate),
            Stop = ToDate(item.ToDate ?? throw new InvalidDataException()),
            Description = description,
            Tag = $"{item.Amount}{GetUnit(item.Unit)} {item.Details}",
            Type = (int)EventTypes.Feeding,
            Source = FileTypes.BabyTracker,
        });
    }

    private string GetUnit(string unit)
    {
        return unit.ToUpper() switch
        {
            "NONE" => string.Empty,
            "MILLIMETERS" => "mm",
            "MILLILITRES" => "mL",
            _ => throw new NotSupportedException(),
        };
    }

    private DateTime ToDate(string date)
    {
        return DateTime.Parse(date);
    }

    private async Task ImportHealth(Record item)
    {
        switch (item.Subtype.ToUpper())
        {
            case "HEALTH_VACCINATIONS":
                await ImportMetric(new CreateMetric()
                {
                    Value = "Vaccination: " + item.Details,
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Medication,
                });
                break;
            case "HEALTH_MEDICATIONS":
                await ImportMetric(new CreateMetric()
                {
                    Value = item.Details,
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Medication,
                });
                break;
            case "HEALTH_TEMPERATURE":
                await ImportMetric(new CreateMetric()
                {
                    Value = item.Amount.ToString(),
                    Date = ToDate(item.FromDate),
                    Source = FileTypes.BabyTracker,
                    Type = (int)MetricTypes.Temperature,
                });
                break;
            default:
                throw new NotSupportedException();
        }
    }
}
