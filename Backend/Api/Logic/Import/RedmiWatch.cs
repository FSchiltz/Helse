using System.Globalization;
using Api.Data;
using Api.Data.Models;
using Api.Models;
using CsvHelper;
using LinqToDB;
using Newtonsoft.Json;

namespace Api.Logic.Import;

internal class RedmiRecord
{
    public string? Uid { get; set; }
    public string? Sid { get; set; }
    public string? Key { get; set; }
    public int Time { get; set; }
    public string? Value { get; set; }

    public string GetKey()
    {
        return $"{Key}_{Time}";
    }
}

public class SleepTime
{
    public int End_time { get; set; }
    public int State { get; set; }
    public int Start_time { get; set; }

    public string GetKey() => +Start_time + "_" + End_time;
}

public class SleepRecord
{
    public int avg_hr { get; set; }
    public int bedtime { get; set; }
    public int sleep_deep_duration { get; set; }
    public int device_bedtime { get; set; }
    public int device_wake_up_time { get; set; }
    public int sleep_light_duration { get; set; }
    public int max_hr { get; set; }
    public int min_hr { get; set; }
    public int protoTime { get; set; }
    public int sleep_rem_duration { get; set; }
    public int Duration { get; set; }
    public List<SleepTime> Items { get; set; }
    public int timezone { get; set; }
    public int version { get; set; }
    public int awake_count { get; set; }
    public int sleep_awake_duration { get; set; }
    public int wake_up_time { get; set; }
}

internal enum SleepType
{
    None,
    State1,
    State2,
    State3,
    State4,
}

internal class Record
{
    public int? Date_time { get; set; }
    public int? Time { get; set; }
    public int Timezone { get; set; }
}

internal class SpoRecord : Record
{
    public string? Spo2 { get; set; }
}

internal class HeartRecord : Record
{
    public string? Bpm { get; set; }
}

internal class StepRecord : Record
{
    public string? Steps { get; set; }
    public string? Distance { get; set; }
}

internal class CalorieRecord : Record
{
    public string? Calories { get; set; }
}

internal class WeightRecord : Record
{
    public string? Weight { get; set; }
}

public class RedmiWatch : FileImporter
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

    public RedmiWatch(string file, AppDataConnection dataConnection, Data.Models.User user) : base(file, dataConnection, user) { }

    public override async Task Import()
    {
        // Remdi fiel are csv, we first convert them
        using var reader = new StringReader(File);
        using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);
        var records = csv.GetRecords<RedmiRecord>();

        // for each record, find the type
        foreach (var record in records)
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
                        await ImportEvent(new Data.Models.Event()
                        {
                            PersonId = User.PersonId,
                            UserId = User.Id,
                            Start = DateTimeOffset.FromUnixTimeSeconds(item.Start_time).DateTime,
                            Stop = DateTimeOffset.FromUnixTimeSeconds(item.End_time).DateTime,
                            Tag = item.GetKey(),
                            Type = (int)EventTypes.Sleep,
                            Description = ((SleepType)item.State).ToString(),
                        });
                    }
                    break;
                case Weight:
                    if (record.Value == null)
                        continue;

                    var weight = JsonConvert.DeserializeObject<WeightRecord>(record.Value);
                    if (weight?.Weight == null)
                        continue;

                    await ImportMetric(new Data.Models.Metric()
                    {
                        PersonId = User.PersonId,
                        UserId = User.Id,
                        Tag = record.GetKey(),
                        Value = weight.Weight,
                        Date = DateTimeOffset.FromUnixTimeSeconds(weight.Time ?? weight.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Wheight,
                    });
                    break;
                case Steps:
                    if (record.Value == null)
                        continue;

                    var steps = JsonConvert.DeserializeObject<StepRecord>(record.Value);
                    if (steps?.Steps == null)
                        continue;

                    await ImportMetric(new Data.Models.Metric()
                    {
                        PersonId = User.PersonId,
                        UserId = User.Id,
                        Tag = record.GetKey(),
                        Value = steps.Steps,
                        Date = DateTimeOffset.FromUnixTimeSeconds(steps.Time ?? steps.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Steps,
                    });
                    break;
                case Calories:
                    if (record.Value == null)
                        continue;

                    var calorie = JsonConvert.DeserializeObject<CalorieRecord>(record.Value);
                    if (calorie?.Calories == null)
                        continue;

                    await ImportMetric(new Data.Models.Metric()
                    {
                        PersonId = User.PersonId,
                        UserId = User.Id,
                        Tag = record.GetKey(),
                        Value = calorie.Calories,
                        Date = DateTimeOffset.FromUnixTimeSeconds(calorie.Time ?? calorie.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Calories,
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

                    await ImportMetric(new Data.Models.Metric()
                    {
                        PersonId = User.PersonId,
                        UserId = User.Id,
                        Tag = record.GetKey(),
                        Value = heart.Bpm,
                        Date = DateTimeOffset.FromUnixTimeSeconds(heart.Time ?? heart.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Heart,
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

                    await ImportMetric(new Data.Models.Metric()
                    {
                        PersonId = User.PersonId,
                        UserId = User.Id,
                        Tag = record.GetKey(),
                        Value = spo.Spo2,
                        Date = DateTimeOffset.FromUnixTimeSeconds(spo.Time ?? spo.Date_time ?? 0).DateTime,
                        Type = (long)MetricTypes.Oxygen,
                    });
                    break;
                default:
                    break;
            }
        }
    }

    private async Task ImportEvent(Data.Models.Event metric)
    {
        using var transaction = await DataConnection.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await DataConnection.GetTable<Api.Data.Models.Event>().FirstOrDefaultAsync(x => x.PersonId == metric.PersonId && x.Tag == metric.Tag);

        if (fromDb == null)
        {
            await DataConnection.GetTable<Data.Models.Event>().InsertAsync(() => new Data.Models.Event
            {
                PersonId = metric.PersonId,
                Description = metric.Description,
                Start = metric.Start,
                Stop = metric.Stop,
                Tag = metric.Tag,
                UserId = metric.UserId,
                Type = metric.Type,
            });
        }

        // else import if

        await transaction.CommitAsync();
    }

    private async Task ImportMetric(Data.Models.Metric metric)
    {
        using var transaction = await DataConnection.BeginTransactionAsync();

        // check if the metric exists
        var fromDb = await DataConnection.GetTable<Api.Data.Models.Metric>().FirstOrDefaultAsync(x => x.PersonId == metric.PersonId && x.Tag == metric.Tag);

        if (fromDb == null)
        {
            await DataConnection.GetTable<Data.Models.Metric>().InsertAsync(() => new Data.Models.Metric
            {
                PersonId = metric.PersonId,
                Value = metric.Value,
                Date = metric.Date,
                Tag = metric.Tag,
                UserId = metric.UserId,
                Type = metric.Type,
            });
        }

        // else import if

        await transaction.CommitAsync();
    }
}