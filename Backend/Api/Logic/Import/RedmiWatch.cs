using System.Globalization;
using Api.Data;
using Api.Logic.Import.Redmi;
using Api.Models;
using CsvHelper;
using Newtonsoft.Json;

namespace Api.Logic.Import;

public class RedmiWatch(string file, IHealthContext db, Data.Models.User user) : FileImporter(file, db, user)
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

    public override async Task Import()
    {
        // Remdi fiel are csv, we first convert them
        using var reader = new StringReader(File);
        using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);

        // for each record, find the type
        foreach (var record in csv.GetRecords<RedmiRecord>())
        {
            switch (record.Key)
            {
                case Sleep:
                    if (record.Value == null)
                        continue;

                    var sleep = JsonConvert.DeserializeObject<SleepRecord>(record.Value);
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

                    var weight = JsonConvert.DeserializeObject<WeightRecord>(record.Value);
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

                    var steps = JsonConvert.DeserializeObject<StepRecord>(record.Value);
                    if (steps?.Steps == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = steps.Steps,
                        Date = DateTimeOffset.FromUnixTimeSeconds(steps.Time ?? steps.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Steps,
                        Source = FileTypes.RedmiWatch,
                    });
                    break;
                case Calories:
                    if (record.Value == null)
                        continue;

                    var calorie = JsonConvert.DeserializeObject<CalorieRecord>(record.Value);
                    if (calorie?.Calories == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = calorie.Calories,
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

                    var heart = JsonConvert.DeserializeObject<HeartRecord>(record.Value);
                    if (heart?.Bpm == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = heart.Bpm,
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

                    var spo = JsonConvert.DeserializeObject<SpoRecord>(record.Value);
                    if (spo?.Spo2 == null)
                        continue;

                    await ImportMetric(new CreateMetric()
                    {
                        Tag = record.GetKey(),
                        Value = spo.Spo2,
                        Date = DateTimeOffset.FromUnixTimeSeconds(spo.Time ?? spo.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Oxygen,
                        Source = FileTypes.RedmiWatch,
                    });
                    break;
                default:
                    break;
            }
        }
    }
}
