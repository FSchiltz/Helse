using System.Text.Json;
using Api.Data;
using Api.Jobs;
using Api.Models.Imports;
using Api.Models.Metrics;

namespace Api.Logic.Import.Clue;

public class ClueImporter(Stream file, IHealthContext db, long user, long patient) : FileImporter(file, db, user, patient)
{
    private readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public override async Task<ImportsResult> Import(IImportQueue queue, Guid id)
    {
        // parse the file as an arry of json object
        var json = await JsonSerializer.DeserializeAsync<ClueItem[]>(File, _options);
        if (json is null)
        {
            return new(new(0, 0, 0), new(0, 0, 0));
        }

        int i = 0;
        long skips = 0;
        long adds = 0;
        foreach (var node in json)
        {
            if (node.Date is null || node.Value?.Any() != true)
            {
                i++;
                skips++;
                continue;
            }

            foreach (var value in node.Value.Where(x => x.Option is not null))
            {
                var (type, subValue) = GetType(node.Type);
                var metric = new CreateMetric
                {
                    Type = (int)type,
                    SourceId = node.Id + value.Option,
                    Source = FileTypes.Clue,
                    Date = DateTime.Parse(node.Date),
                    Value = $"{subValue}{value.Option?.Replace('_', ' ')}",
                };
                // import the data
                var added = await ImportMetric(metric);
                if (added)
                {
                    adds++;
                }
                else
                {
                    skips++;
                }
            }

            queue.Progress(id, i / json.Length * 100);
            i++;
        }

        return new(new(adds, skips, 0), new(0, 0, 0));
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