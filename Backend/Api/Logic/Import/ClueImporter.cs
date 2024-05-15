using Api.Data;
using Api.Data.Models;
using Api.Logic.Import.Clue;
using Api.Models;
using Newtonsoft.Json;

namespace Api.Logic.Import;

public class ClueImporter(string file, IHealthContext db, User user) : FileImporter(file, db, user)
{
    public override async Task Import()
    {
        // parse the file as an arry of json object
        var json = JsonConvert.DeserializeObject<ClueItem[]>(File);
        if (json is null)
        {
            return;
        }

        foreach (var node in json)
        {
            if (node.Date is null || node.Value?.Any() != true)
                continue;

            foreach (var value in node.Value.Where(x => x.Option is not null))
            {
                var (type, subValue) = GetType(node.Type);
                var metric = new CreateMetric
                {
                    Type = (int)type,
                    Tag = node.Id + value.Option,
                    Source = FileTypes.Clue,
                    Date = DateTime.Parse(node.Date),
                    Value = subValue + value.Option!,
                };
                // import the data
                await ImportMetric(metric);
            }
        }
    }

    private static (MetricTypes, string?) GetType(string? type) => type switch
    {
        "medication" => (MetricTypes.Medication, null),
        "birth_control_ring" => (MetricTypes.Medication, "Birth control ring "),
        "birth_control_pill" => (MetricTypes.Medication, "Birth control pill "),
        "mind" => (MetricTypes.Mood, null),
        "pain" => (MetricTypes.Pain, null),
        "sex_life" => (MetricTypes.Sex, null),
        "stool" => (MetricTypes.Stool, null),
        "energy" => (MetricTypes.Mood, null),
        "spotting" => (MetricTypes.Spotting, null),
        "period" => (MetricTypes.Menstruation, null),
        "discharge" => (MetricTypes.Menstruation, "discharge "),
        "feelings" => (MetricTypes.Mood, null),
        "pms" => (MetricTypes.Pain, "Premenstrual syndrome "),
        "tests" => (MetricTypes.Tests, null),
        _ => throw new InvalidDataException(type),
    };
}