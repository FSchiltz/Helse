using System.Buffers;
using System.Globalization;
using System.Text;
using System.Text.Json;
using Api.Data;
using Api.Jobs;
using Api.Logic.Import.Redmi;
using Api.Models;
using Api.Models.Events;
using Api.Models.Metrics;
using CsvHelper;

namespace Api.Logic.Import;

public class RedmiWatch(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
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

    public override async Task Import(IImportQueue queue, Guid id)
    {
        // Remdi fiel are csv, we first convert them
        using var reader = new StreamReader(File);
        using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);

        long read = 0;

        // for each record, find the type
        foreach (var record in csv.GetRecords<RedmiRecord>())
        {
            switch (record.Key)
            {
                case Sleep:
                    if (record.Value == null)
                        continue;

                    var sleep = JsonSerializer.Deserialize<SleepRecord>(record.Value, _options);
                    if (sleep?.Items == null)
                        continue;

                    foreach (var item in sleep.Items)
                    {
                        await ImportEvent(new CreateEvent()
                        {
                            Start = DateTimeOffset.FromUnixTimeSeconds(item.Start_time).DateTime,
                            Stop = DateTimeOffset.FromUnixTimeSeconds(item.End_time).DateTime,
                            Tag = item.GetKey(),
                            Type = (int)EventTypes.Sleep,
                            Description = item.State.ToString(),
                        });
                    }
                    break;
                case Weight:
                    if (record.Value == null)
                        continue;

                    var weight = JsonSerializer.Deserialize<WeightRecord>(record.Value, _options);
                    if (weight?.Weight == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = weight.Weight,
                        Date = DateTimeOffset.FromUnixTimeSeconds(weight.Time ?? weight.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Wheight,
                        Source = FileTypes.RedmiWatch,
                    });
                    break;
                case Steps:
                    if (record.Value == null)
                        continue;

                    var steps = JsonSerializer.Deserialize<StepRecord>(record.Value, _options);
                    if (steps?.Steps == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = steps.Steps.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(steps.Time ?? steps.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Steps,
                        Source = FileTypes.RedmiWatch,
                    });
                    break;
                case Calories:
                    if (record.Value == null)
                        continue;

                    var calorie = JsonSerializer.Deserialize<CalorieRecord>(record.Value, _options);
                    if (calorie?.Calories == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = calorie.Calories.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(calorie.Time ?? calorie.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Calories,
                        Source = FileTypes.RedmiWatch,
                    });
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

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = heart.Bpm.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(heart.Time ?? heart.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Heart,
                        Source = FileTypes.RedmiWatch,
                    });
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

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = spo.Spo2.ToString(),
                        Date = DateTimeOffset.FromUnixTimeSeconds(spo.Time ?? spo.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Oxygen,
                        Source = FileTypes.RedmiWatch,
                    });
                    break;
            }

            read = File.Position;
            queue.Progress(id, read / (double)File.Length * 100);
        }

        queue.Stop(id);
    }
}
