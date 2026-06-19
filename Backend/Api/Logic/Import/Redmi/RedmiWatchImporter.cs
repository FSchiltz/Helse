using System.Buffers;
using System.Globalization;
using System.Text;
using System.Text.Json;
using Helse.Api.Data;
using CsvHelper;
using Helse.Models.Events;
using Helse.Models.Imports;
using Helse.Models.Metrics;
using Api.Logic.Import.Redmi;
using Helse.Api.Jobs;

namespace Helse.Api.Logic.Import.Redmi;

internal class RedmiWatchImporter(Stream file, IEventContext eventDb,IMetricContext metricDb, long user, long patient) : FileImporter(file, eventDb, metricDb, user, patient)
{
    private const string MaxSpo = "max_spo2";
    private const string MinSpo = "min_spo2";
    private const string Spo = "spo2";
    private const string SingleSpo = "single_spo";

    private const string MinHeart = "min_heart_rate";
    private const string MaxHeart = "max_heart_rate";
    private const string RestingHeart = "resting_heart_rate";
    private const string HeartRate = "heart_rate";
    private const string SingleHeart = "single_heart_rate";

    private const string Calories = "calories";

    private const string Steps = "steps";

    private const string Sleep = "sleep";

    private const string Weight = "weight";

    private readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new ForgivingStringConverter() }
    };

    public sealed class ForgivingStringConverter : System.Text.Json.Serialization.JsonConverter<string>
    {
        public override string? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            return reader.TokenType switch
            {
                JsonTokenType.False => "false",
                JsonTokenType.True => "true",
                JsonTokenType.Number => Encoding.UTF8.GetString(reader.HasValueSequence ? reader.ValueSequence.ToArray() : reader.ValueSpan),
                _ => reader.GetString(),
            };
        }

        public override void Write(Utf8JsonWriter writer, string value, JsonSerializerOptions options)
        {
            writer.WriteStringValue(value);
        }
    }

    public override async Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        // Remdi fiel are csv, we first convert them
        using var reader = new StreamReader(File);
        using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);

        long read = 0;

        long metricAdds = 0;
        long metricSkips = 0;
        long eventAdds = 0;
        long eventSkips = 0;
        // for each record, find the type
        foreach (var record in csv.GetRecords<RedmiRecord>())
        {
            CreateEvent[] createEvent = [];
            CreateMetric[] createMetric = [];

            switch (record.Key)
            {
                case Sleep:
                    if (record.Value == null)
                        continue;

                    var sleep = JsonSerializer.Deserialize<SleepRecord>(record.Value, _options);
                    if (sleep?.Items == null)
                        continue;


                    createEvent = [.. sleep.Items.Select(item => new CreateEvent()
                    {
                        Start = DateTimeOffset.FromUnixTimeSeconds(item.Start_time).DateTime,
                        Stop = DateTimeOffset.FromUnixTimeSeconds(item.End_time).DateTime,
                        Type = (int)EventTypes.Sleep,
                        Description = item.State.ToString(),
                        SourceId = item.GetKey(),
                        Source = FileTypes.RedmiWatch,
                    })];

                    break;
                case Weight:
                    if (record.Value == null)
                        continue;

                    var weight = JsonSerializer.Deserialize<WeightRecord>(record.Value, _options);
                    if (weight?.Weight == null)
                        continue;

                    createMetric = [new CreateMetric()
                    {
                        SourceId = record.GetKey(),
                        Value = weight.Weight,
                        Date = DateTimeOffset.FromUnixTimeSeconds(weight.Time ?? weight.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Wheight,
                        Source = FileTypes.RedmiWatch,
                    }];
                    break;
                case Steps:
                    if (record.Value == null)
                        continue;

                    var steps = JsonSerializer.Deserialize<StepRecord>(record.Value, _options);
                    if (steps?.Steps == null)
                        continue;

                    createMetric = [new CreateMetric()
                    {
                        SourceId = record.GetKey(),
                        Value = steps.Steps.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(steps.Time ?? steps.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Steps,
                        Source = FileTypes.RedmiWatch,
                    }];
                    break;
                case Calories:
                    if (record.Value == null)
                        continue;

                    var calorie = JsonSerializer.Deserialize<CalorieRecord>(record.Value, _options);
                    if (calorie?.Calories == null)
                        continue;

                    createMetric = [
                        new CreateMetric()
                    {
                        SourceId = record.GetKey(),
                        Value = calorie.Calories.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(calorie.Time ?? calorie.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Calories,
                        Source = FileTypes.RedmiWatch,
                    }];
                    break;
                case MaxHeart:
                case MinHeart:
                case RestingHeart:
                case HeartRate:
                case SingleHeart:
                    if (record.Value == null)
                        continue;

                    var heart = JsonSerializer.Deserialize<HeartRecord>(record.Value, _options);
                    if (heart?.Bpm == null)
                        continue;

                    createMetric = [new CreateMetric()
                    {
                        SourceId = record.GetKey(),
                        Value = heart.Bpm.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(heart.Time ?? heart.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Heart,
                        Source = FileTypes.RedmiWatch,
                    }];
                    break;
                case MaxSpo:
                case MinSpo:
                case Spo:
                case SingleSpo:
                    if (record.Value == null)
                        continue;

                    var spo = JsonSerializer.Deserialize<SpoRecord>(record.Value, _options);
                    if (spo?.Spo2 == null)
                        continue;

                    createMetric = [new CreateMetric()
                    {
                        SourceId = record.GetKey(),
                        Value = spo.Spo2.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(spo.Time ?? spo.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Oxygen,
                        Source = FileTypes.RedmiWatch,
                    }];
                    break;
            }

            foreach (var e in createEvent)
            {
                var added = await ImportEvent(e);
                if (added)
                {
                    eventAdds++;
                }
                else
                {
                    eventSkips++;
                }
            }

            foreach (var e in createMetric)
            {
                var added = await ImportMetric(e);
                if (added)
                {
                    metricAdds++;
                }
                else
                {
                    metricSkips++;
                }
            }
            read = File.Position;
            queue.Progress(id, read / (double)File.Length * 100);
        }

        return new(new(metricAdds, metricSkips, 0), new(eventAdds, eventSkips, 0));
    }
}
