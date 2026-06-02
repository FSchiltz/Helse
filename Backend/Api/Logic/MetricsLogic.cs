using Api.Data;
using Api.Helpers;
using Api.Models;
using Api.Models.Metrics;
using Api.Models.Persons;
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
            SourceId = x.SourceId,
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

        Data.Models.Health.Metric[] metrics;
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
            SourceId = x.SourceId,
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

    private static void Validate(MetricBase metric, Data.Models.Health.MetricType? type)
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

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool? all, long? group, IHealthContext db) => TypedResults.Ok((await db.GetMetricTypes(all, group)).Select(metric => new MetricType
    {
        Name = metric.Name,
        Description = metric.Description,
        SummaryType = (MetricSummary)metric.SummaryType,
        Type = (MetricDataType)metric.Type,
        Unit = metric.Unit,
        Id = metric.Id,
        Visible = metric.Visible,
        UserEditable = metric.UserEditable,
        ShowOnDashboard = metric.ShowOnDashboard,
        GroupId = metric.GroupId
    }));

    public static async Task<IResult> CreateTypeAsync(MetricType metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        if (metric.Type == MetricDataType.Text && metric.SummaryType != MetricSummary.Latest)
        {
            throw new InvalidDataException("Text can only be summarized with latest");
        }

        await db.Insert(metric);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateTypeAsync(MetricType metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        if (metric.Type == MetricDataType.Text && metric.SummaryType != MetricSummary.Latest)
        {
            throw new InvalidDataException("Text can only be summarized with latest");
        }

        await db.Update(metric);

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

    public static async Task<IResult> GetGroupsAsync(IHealthContext db) => TypedResults.Ok((await db.GetMetricGroups()).Select(metric => new MetricGroup
    {
        Name = metric.Name,
        Description = metric.Description,
        ShowOnDashboard = metric.ShowOnDashboard,
        ShowTitle = metric.ShowTitle,
        Id = metric.Id,
    }));

    public static async Task<IResult> CreateGroupAsync(MetricGroup metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.Insert(metric);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateGroupAsync(MetricGroup metric, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.Update(metric);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteGroupAsync(long id, IUserContext users, IHealthContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        var count = await db.DeleteMetricGroup(id);

        if (count == 1)
            return TypedResults.NoContent();
        else
            return TypedResults.BadRequest();
    }
}