using System.Data;
using Helse.Api.Data.Helpers;
using Helse.Api.Data.Models.Health;
using Helse.Models.Common;
using LinqToDB;
using LinqToDB.Async;
using LinqToDB.Data;
using LinqToDB.Mapping;

namespace Helse.Api.Data;

internal class MetricContext(DataConnection db, SlowQueryLogInterceptor interceptor)
: BaseContext(db, interceptor), IMetricContext
{
    /// <summary>
    /// Chunked metric for the summary
    /// </summary>
    private class ChunkedMetric : Metric
    {
        [Column, NotNull]
        public int Chunk { get; set; }
    }

    private class Chunked
    {
        [Column, NotNull]
        public int Chunk { get; set; }

        [Column, NotNull]
        public DateTime Date { get; set; }

        [Column, NotNull]
        public string? Value { get; set; }
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Insert(Helse.Models.Metrics.CreateMetricType metric)
    {
        return Db.GetTable<MetricType>().InsertAsync(() => new MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            Unit = metric.Unit,
            SummaryType = (long)metric.SummaryType,
            Type = (long)metric.Type,
            UserEditable = true,
            Visible = metric.Visible,
            GroupId = metric.GroupId,
            ShowOnDashboard = metric.ShowOnDashboard,
            ValueCount = metric.ValueCount,
            TimeDifference = metric.TimeDifference,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<long> Insert(Helse.Models.Metrics.CreateMetric metric, long person, long user)
    {
        return Db.GetTable<Metric>().InsertWithInt64IdentityAsync(() => new Metric
        {
            PersonId = person,
            Value = metric.Value,
            Date = metric.Date,
            Tag = metric.Tag,
            UserId = user,
            Type = metric.Type,
            Source = (int)metric.Source,
            SourceId = metric.SourceId,
            Created = DateTime.UtcNow,
        });
    }


    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(Helse.Models.Metrics.UpdateMetricType metric)
    {
        return Db.GetTable<MetricType>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Name, metric.Name)
            .Set(x => x.Description, metric.Description)
            .Set(x => x.Unit, metric.Unit)
            .Set(x => x.Type, (long)metric.Type)
            .Set(x => x.SummaryType, (long)metric.SummaryType)
            .Set(x => x.Visible, metric.Visible)
            .Set(x => x.ShowOnDashboard, metric.ShowOnDashboard)
            .Set(x => x.GroupId, metric.GroupId)
            .Set(x => x.ValueCount, metric.ValueCount)
            .Set(x => x.TimeDifference, metric.TimeDifference)
            .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<bool> ExistsMetric(long person, long type, int source, string sourceId)
    => Db.GetTable<Metric>().AnyAsync(x => x.PersonId == person && x.Type == type && x.SourceId == sourceId && x.Source == source);

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public async Task<Metric[]> GetSummaryMetrics(int tile, long id, int type, Helse.Models.Metrics.MetricSummary action, DateTime start, DateTime end)
    {
        // Use a manual command to use the SQL function NTILE
        var groups = Db.FromSql<ChunkedMetric>($"SELECT NTILE({tile}) OVER (ORDER BY date) as chunk,* FROM health.metric m WHERE m.PersonId = {id} AND m.Type = {type} AND m.Date <= {end} AND m.Date >= {start}")
         .AsSubQuery()
         .GroupBy(x => x.Chunk);
        IQueryable<Chunked> query = action switch
        {
            Helse.Models.Metrics.MetricSummary.Mean => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Average(y => Sql.Convert<double, string>(y.Value)).ToString(),
            }),
            Helse.Models.Metrics.MetricSummary.Sum => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Sum(y => Sql.Convert<double, string>(y.Value)).ToString(),
            }),
            _ => groups.Select(x => new Chunked
            {
                Chunk = x.Key,
                Date = x.Min(y => y.Date),
                Value = x.Min(y => y.Value),
            }),
        };
        var chunks = await query.OrderBy(x => x.Chunk)
       .ToArrayAsync();

        return [.. chunks.Select(x => new Metric
        {
            Date = x.Date,
            Value = x.Value ?? string.Empty,
            Tag = x.Chunk.ToString(),
        })];
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Metric[]> GetLastMetrics(long id, int count, int type, DateTime start, DateTime end)
    {
        return Db.GetTable<Metric>().Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
                .OrderByDescending(x => x.Date)
                .Take(count)
                .ToArrayAsync();
    }

    public Task Update(Helse.Models.Metrics.UpdateMetric metric)
    {
        return Db.GetTable<Metric>()
            .Where(x => x.Id == metric.Id)
            .Set(x => x.Date, metric.Date)
            .Set(x => x.Tag, metric.Tag)
            .Set(x => x.Value, metric.Value)
            .Set(x => x.Source, (int)metric.Source)
            .Set(x => x.SourceId, metric.SourceId)
            .UpdateAsync();
    }

    public Task<int> DeleteMetricGroup(long id) => Db.GetTable<MetricGroup>().DeleteAsync(x => x.Id == id);

    public Task Update(Helse.Models.Metrics.UpdateGroup metricGroup)
    {
        return Db.GetTable<MetricGroup>()
            .Where(x => x.Id == metricGroup.Id)
            .Set(x => x.Name, metricGroup.Name)
            .Set(x => x.Description, metricGroup.Description)
            .Set(x => x.ShowOnDashboard, metricGroup.ShowOnDashboard)
            .Set(x => x.ShowTitle, metricGroup.ShowTitle)
            .UpdateAsync();
    }

    public Task Insert(Helse.Models.Metrics.CreateGroup metricGroup)
    {
        return Db.GetTable<MetricGroup>().InsertAsync(() => new MetricGroup
        {
            Name = metricGroup.Name,
            Description = metricGroup.Description,
            ShowOnDashboard = metricGroup.ShowOnDashboard,
            ShowTitle = metricGroup.ShowTitle,
        });
    }

    public Task<MetricGroup[]> GetMetricGroups() => Db.GetTable<MetricGroup>().OrderBy(x => x.Id).ToArrayAsync();

    public Task<Metric[]> SearchMetricsAsync(long person, Helse.Models.Metrics.SearchMetric search, Pagination pagination)
    {
        var query = Db.GetTable<Metric>()
        .Where(x => x.Type == search.Type && x.PersonId == person)
        .ApplyFilter(search)
        .Skip(pagination.Page * pagination.PageSize).Take(pagination.PageSize); ;

        return query.ToArrayAsync();
    }

    public Task<long> CountMetricsAsync(long person, Helse.Models.Metrics.SearchMetric search)
    {
        var query = Db.GetTable<Metric>()
        .Where(x => x.Type == search.Type && x.PersonId == person)
        .ApplyFilter(search);

        return query.LongCountAsync();
    }

    /// <inheritdoc/>
    public Task DeleteMetric(long id, long personId) => Db.GetTable<Metric>().DeleteAsync(x => x.Id == id && x.PersonId == personId);

    /// <inheritdoc/>
    public Task<int> DeleteMetricType(long id) => Db.GetTable<MetricType>().DeleteAsync(x => x.Id == id && x.UserEditable);



    /// <inheritdoc/>
    public Task<Metric?> GetMetric(long id)
    {
        IQueryable<Metric> query = Db.GetTable<Metric>().LoadWith(x => x.UnitObject);
        return query.FirstOrDefaultAsync(x => x.Id == id);
    }

    /// <inheritdoc/>
    public Task<Metric[]> GetMetrics(long id, long type, DateTime start, DateTime end)
    {
        IQueryable<Metric> query = Db.GetTable<Metric>().LoadWith(x => x.UnitObject);
        return query.Where(x => x.PersonId == id
                && x.Type == type
                && x.Date <= end && x.Date >= start)
            .OrderBy(x => x.Date)
            .ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<MetricType[]> GetMetricTypes(bool? all, long? group)
    {
        IQueryable<MetricType> query = Db.GetTable<MetricType>().LoadWith(x => x.UnitObject);

        if (all == false)
        {
            query = query.Where(x => x.Visible);
        }

        if (group is not null)
        {
            query = query.Where(x => x.GroupId == group);
        }

        return query.OrderBy(x => x.Id).ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<MetricType?> GetMetricType(long type)
    {
        IQueryable<MetricType> query = Db.GetTable<MetricType>().LoadWith(x => x.UnitObject);

        return query.FirstOrDefaultAsync(x => x.Id == type);
    }
    public Task DeleteMetrics(long[] ids, long person)
    {
        return Db.GetTable<Metric>().DeleteAsync(x => ids.Contains(x.Id) && x.PersonId == person);
    }

    public Task UpdateBulk(Helse.Models.Metrics.PatchMetric metric, long person)
    {
        var query = Db.GetTable<Metric>()
        .Where(x => metric.Ids.Contains(x.Id))
        .Where(x => x.PersonId == person).AsUpdatable();

        if (metric.UpdateDate)
        {
            query = query.Set(x => x.Date, metric.Date);
        }

        if (metric.UpdateValue)
        {
            query = query.Set(x => x.Value, metric.Value);
        }

        if (metric.UpdateTag)
        {
            query = query.Set(x => x.Tag, metric.Tag);
        }

        return query.UpdateAsync();
    }
}
