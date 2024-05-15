

using System.Text.Json.Nodes;
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

            var metric = new CreateMetric
            {
                Type = (int)GetType(node.Type),
                Tag = node.Id,
                Source = FileTypes.Clue,
                Date = DateTime.Parse(node.Date),
                Value = node.Value?[0].Option ?? "",
            };

            // import the data
            await this.ImportMetric(metric);
        }
    }

    private static MetricTypes GetType(string? type) => type switch
    {
        "period" => MetricTypes.Menstruation,
        "feelings" => MetricTypes.Mood,
        _ => throw new InvalidDataException(),
    };
}