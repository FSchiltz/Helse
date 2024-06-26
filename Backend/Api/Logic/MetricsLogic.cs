using Api.Data;
using Api.Helpers;
using Api.Models;
using CsvHelper;
using LinqToDB;

namespace Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
public static class MetricsLogic
{
    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var metrics = await db.GetMetrics(id, type, start, end);

        return TypedResults.Ok(metrics.Select(x => new Metric
        {
            Value = x.Value,
            Date = DateTime.SpecifyKind(x.Date, DateTimeKind.Utc),
            Id = x.Id,
            Person = user.PersonId,
            Type = x.Type,
            Tag = x.Tag,
            User = x.UserId,
            Source = (FileTypes)x.Source,
        }));
    }

    public async static Task<IResult> GetSummaryAsync(int tile, int type, DateTime start, DateTime end, long? personId, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var metricType = await db.GetMetricType(type) ?? throw new InvalidDataException("Incorrect metric type: " + type);

        Api.Data.Models.Metric[] metrics;
        if (metricType.Type == (long)MetricDataType.Text)
        {
            var last = await db.GetLastMetrics(id, type, start, end);
            if (last is not null)
                metrics = [last];
            else
                metrics = [];
        }
        else
        {
            metrics = await db.GetSummaryMetrics(tile, id, type, (MetricSummary)metricType.SummaryType, start, end);
        }

        return TypedResults.Ok(metrics.Select(x => new Metric
        {
            Value = x.Value,
            Date = DateTime.SpecifyKind(x.Date, DateTimeKind.Utc),
            Id = x.Id,
            Person = user.PersonId,
            Type = x.Type,
            Tag = x.Tag,
            User = x.UserId,
            Source = (FileTypes)x.Source,
        }));
    }

    public static async Task<IResult> CreateAsync(CreateMetric metric, long? personId, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        // TODO add caching here
        var type = await db.GetMetricType((int)metric.Type);

        Validate(metric, type);

        await db.Insert(metric, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    private static void Validate(MetricBase metric, Data.Models.MetricType? type)
    {
        if (type == null)
            throw new InvalidDataException("Type not found");

        if ((MetricDataType)type.Type == MetricDataType.Number && !int.TryParse(metric.Value, out var _))
            throw new InvalidDataException("The metric value is not a number");
    }

    public static async Task<IResult> UpdateAsync(UpdateMetric metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var existing = await db.GetMetric(metric.Id) ?? throw new InvalidDataException("Id not found");

        if (existing.PersonId != user.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        var type = await db.GetMetricType((int)metric.Type);

        Validate(metric, type);

        await db.Update(metric);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, IUserContext users, IHealthContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        await using var transaction = await db.BeginTransactionAsync();

        var existing = await db.GetMetric(id);
        if (existing is null)
            return TypedResults.NoContent();

        if (user.PersonId != existing.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await db.DeleteMetric(id);

        transaction.Commit();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool? all, IHealthContext db) => TypedResults.Ok((await db.GetMetricTypes(all)).Select(metric => new Models.MetricType
    {
        Name = metric.Name,
        Description = metric.Description,
        SummaryType = (MetricSummary)metric.SummaryType,
        Type = (MetricDataType)metric.Type,
        Unit = metric.Unit,
        Id = metric.Id,
        Visible = metric.Visible,
        UserEditable = metric.UserEditable,
    }));

    public static async Task<IResult> CreateTypeAsync(Models.MetricType metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        if (metric.Type == MetricDataType.Text && metric.SummaryType != MetricSummary.Latest)
        {
            throw new InvalidDataException("Text can only be summarized with latest");
        }

        await db.Insert(new Data.Models.MetricType
        {
            Name = metric.Name,
            Description = metric.Description,
            SummaryType = (long)metric.SummaryType,
            Type = (long)metric.Type,
            Unit = metric.Unit,
            Visible = metric.Visible,
        });

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(Models.MetricType metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        if (metric.Type == MetricDataType.Text && metric.SummaryType != MetricSummary.Latest)
        {
            throw new InvalidDataException("Text can only be summarized with latest");
        }

        await db.Update(new Data.Models.MetricType
        {
            Id = metric.Id,
            Name = metric.Name,
            Description = metric.Description,
            SummaryType = (long)metric.SummaryType,
            Type = (long)metric.Type,
            Unit = metric.Unit,
            Visible = metric.Visible,
        });

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteTypeAsync(long id, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var count = await db.DeleteMetricType(id);

        if (count == 1)
            return TypedResults.NoContent();
        else
            return TypedResults.BadRequest();
    }
}