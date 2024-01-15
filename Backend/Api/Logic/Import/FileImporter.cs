using Api.Data;
using LinqToDB;

namespace Api.Logic.Import;

public abstract class FileImporter(string file, AppDataConnection dataConnection, Data.Models.User user)
{
    public string File { get; } = file;
    
    public Data.Models.User User { get; } = user;

    public abstract Task Import();
    protected async Task ImportEvent(Data.Models.Event metric)
  {
    using var transaction = await dataConnection.BeginTransactionAsync();

    // check if the event exists
    var fromDb = await dataConnection.GetTable<Api.Data.Models.Event>().AnyAsync(x => x.PersonId == metric.PersonId && x.Tag == metric.Tag);

    if (!fromDb)
    {
      await dataConnection.GetTable<Data.Models.Event>().InsertAsync(() => new Data.Models.Event
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

    await transaction.CommitAsync();
  }


  protected async Task ImportMetric(Data.Models.Metric metric)
  {
    using var transaction = await dataConnection.BeginTransactionAsync();

    // check if the metric exists
    var fromDb = await dataConnection.GetTable<Api.Data.Models.Metric>().AnyAsync(x => x.PersonId == metric.PersonId && x.Tag == metric.Tag);

    if (!fromDb)
    {
      await dataConnection.GetTable<Data.Models.Metric>().InsertAsync(() => new Data.Models.Metric
      {
        PersonId = metric.PersonId,
        Value = metric.Value,
        Date = metric.Date,
        Tag = metric.Tag,
        UserId = metric.UserId,
        Type = metric.Type,
      });
    }

    await transaction.CommitAsync();
  }

}