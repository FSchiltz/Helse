

using System.Text.Json.Nodes;
using Api.Data;
using Api.Data.Models;
using Api.Models;
using Newtonsoft.Json;

namespace Api.Logic.Import;

public class ClueImporter(string file, IHealthContext db, User user) : FileImporter(file, db, user)
{
    public override async Task Import()
    {
        // parse the file as an arry of json object
        var json = JsonConvert.DeserializeObject<JsonArray>(File);
        if (json is null)
        {
            return;
        }

        foreach (var node in json)
        {
            var metric = new CreateMetric
            {
                Value = "",
            };
            
            // import the data
            await this.ImportMetric(metric);
        }
    }
}