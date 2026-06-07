using Api.Data;
using Api.Data.Models.Common;
using Api.Helpers;
using Api.Models.Common;
using Api.Models.Imports;
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
            Value = x.Item.Value,
            Date = DateTime.SpecifyKind(x.Item.Date, DateTimeKind.Utc),
            Id = x.Item.Id,
            Person = user.PersonId,
            Type = x.Item.Type,
            Tag = x.Item.Tag,
            User = x.Item.UserId,
            Source = (FileTypes)x.Item.Source,
            SourceId = x.Item.SourceId,
            Unit = x.Unit?.ToUnit(),
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
        if (metricType.Item.Type == (long)MetricDataType.Text)
        {
            var last = await db.GetLastMetrics(id, type, start, end);
            if (last is not null)
                metrics = [last];
            else
                metrics = [];
        }
        else
        {
            // TODO take into account metric that have a different unit than the parent
            metrics = await db.GetSummaryMetrics(tile, id, type, (MetricSummary)metricType.Item.SummaryType, start, end);
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

    public static async Task<IResult> CreateAsync(CreateMetric metric, long? personId, IUserContext users, IHealthContext db, ICommonContext commonDb, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        // TODO add caching here
        var type = await db.GetMetricType((int)metric.Type);
        Units? unit = null;

        if (metric.Unit is not null)
        {
            unit = (await commonDb.GetUnitAsync(metric.Unit.Value))?.Unit;
        }

        Validate(metric, unit, type);

        await db.Insert(metric, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    private static void Validate(CreateMetric metric, Units? unit, WithUnit<Data.Models.Health.MetricType>? type)
    {
        if (type == null)
            throw new InvalidDataException("Type not found");

        if ((MetricDataType)type.Item.Type == MetricDataType.Number && !int.TryParse(metric.Value, out var _))
            throw new InvalidDataException("The metric value is not a number");

        if (metric.Unit is not null)
        {
            ArgumentNullException.ThrowIfNull(unit);

            if (unit.Type != type.Unit?.Unit.Type)
            {
                throw new InvalidDataException("The metric unit is not in the correct type");
            }
        }
    }

    public static async Task<IResult> UpdateAsync(UpdateMetric metric, IUserContext users, IHealthContext db, ICommonContext commonDb, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var existing = await db.GetMetric(metric.Id) ?? throw new InvalidDataException("Id not found");

        if (existing.Item.PersonId != user.PersonId && !await users.ValidateCaregiverAsync(user, existing.Item.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        var type = await db.GetMetricType((int)metric.Type);
        Units? unit = null;

        if (metric.Unit is not null)
        {
            unit = (await commonDb.GetUnitAsync(metric.Unit.Value))?.Unit;
        }
        Validate(metric, unit, type);

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

        if (user.PersonId != existing.Item.PersonId && !await users.ValidateCaregiverAsync(user, existing.Item.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        await db.DeleteMetric(id);

        await transaction.CommitAsync();

        return TypedResults.NoContent();
    }

    public static async Task<IResult> GetTypeAsync(bool? all, long? group, IHealthContext db) => TypedResults.Ok((await db.GetMetricTypes(all, group)).Select(x => new MetricType
    {
        Name = x.Item.Name,
        Description = x.Item.Description,
        SummaryType = (MetricSummary)x.Item.SummaryType,
        Type = (MetricDataType)x.Item.Type,
        Unit = x.Unit?.ToUnit() ?? throw new InvalidDataException("Missing Unit"),
        Id = x.Item.Id,
        Visible = x.Item.Visible,
        UserEditable = x.Item.UserEditable,
        ShowOnDashboard = x.Item.ShowOnDashboard,
        GroupId = x.Item.GroupId
    }));

    public static async Task<IResult> CreateTypeAsync(CreateMetricType metric, IUserContext users, IHealthContext db, HttpContext context)
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

    public static async Task<IResult> UpdateTypeAsync(UpdateMetricType metric, IUserContext users, IHealthContext db, HttpContext context)
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