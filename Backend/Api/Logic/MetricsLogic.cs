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
    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IMetricContext db, HttpContext context)
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
            Unit = x.UnitObject?.ToUnit(),
        }));
    }

    public async static Task<IResult> GetSummaryAsync(int tile, int type, DateTime start, DateTime end, long? personId, IUserContext users, IMetricContext db, HttpContext context)
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
            // TODO take into account metric that have a different unit than the parent
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

    public static async Task<IResult> CreateAsync(CreateMetric metric, long? personId, IUserContext users, IMetricContext db, ICommonContext commonDb, HttpContext context)
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
            unit = await commonDb.GetUnitAsync(metric.Unit.Value);
        }

        Validate(metric, unit, type);

        await db.Insert(metric, personId ?? user.PersonId, user.Id);

        return TypedResults.NoContent();
    }

    private static void Validate(CreateMetric metric, Units? unit, Data.Models.Health.MetricType? type)
    {
        if (type == null)
            throw new InvalidDataException("Type not found");

        if ((MetricDataType)type.Type == MetricDataType.Number && !double.TryParse(metric.Value, out var _))
            throw new InvalidDataException("The metric value is not a number");

        if ((MetricDataType)type.Type == MetricDataType.MinMax)
        {
            var split = metric.Value.Split(';');
            if (split.Length != 2)
            {
                throw new InvalidDataException("The metric should have 2 value separated by a ';'");
            }

            var first = double.TryParse(split[0], out var _);
            var second = double.TryParse(split[2], out var _);

            if (!first || !second)
            {
                throw new InvalidDataException("The value of the metric should be numbers");
            }
        }

        if (metric.Unit is not null)
        {
            ArgumentNullException.ThrowIfNull(unit);

            if (unit.Type != type.UnitObject?.Type)
            {
                throw new InvalidDataException("The metric unit is not in the correct type");
            }
        }
    }

    public static async Task<IResult> UpdateAsync(UpdateMetric metric, IUserContext users, IMetricContext db, ICommonContext commonDb, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var existing = await db.GetMetric(metric.Id) ?? throw new InvalidDataException("Id not found");

        if (existing.PersonId != user.PersonId && !await users.ValidateCaregiverAsync(user, existing.PersonId, RightType.Edit))
            return TypedResults.Forbid();

        var type = await db.GetMetricType((int)metric.Type);
        Units? unit = null;

        if (metric.Unit is not null)
        {
            unit = await commonDb.GetUnitAsync(metric.Unit.Value);
        }
        Validate(metric, unit, type);

        await db.Update(metric);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteAsync(long id, IUserContext users, IMetricContext db, HttpContext context)
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

    public static async Task<IResult> GetTypeAsync(bool? all, long? group, IMetricContext db)
    => TypedResults.Ok((await db.GetMetricTypes(all, group)).Select(x => new MetricType
    {
        Name = x.Name,
        Description = x.Description,
        SummaryType = (MetricSummary)x.SummaryType,
        Type = (MetricDataType)x.Type,
        Unit = x.UnitObject?.ToUnit() ?? throw new InvalidDataException("Missing Unit"),
        Id = x.Id,
        Visible = x.Visible,
        UserEditable = x.UserEditable,
        ShowOnDashboard = x.ShowOnDashboard,
        GroupId = x.GroupId
    }));

    public static async Task<IResult> CreateTypeAsync(CreateMetricType metric, IUserContext users, IMetricContext db, HttpContext context)
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

    public static async Task<IResult> UpdateTypeAsync(UpdateMetricType metric, IUserContext users, IMetricContext db, HttpContext context)
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

    public async static Task<IResult> DeleteTypeAsync(long id, IUserContext users, IMetricContext db, HttpContext context)
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

    public static async Task<IResult> GetGroupsAsync(IMetricContext db) => TypedResults.Ok((await db.GetMetricGroups()).Select(metric => new MetricGroup
    {
        Name = metric.Name,
        Description = metric.Description,
        ShowOnDashboard = metric.ShowOnDashboard,
        ShowTitle = metric.ShowTitle,
        Id = metric.Id,
    }));

    public static async Task<IResult> CreateGroupAsync(MetricGroup metric, IUserContext users, IMetricContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.Insert(metric);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateGroupAsync(MetricGroup metric, IUserContext users, IMetricContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.Update(metric);

        return TypedResults.NoContent();
    }

    public async static Task<IResult> DeleteGroupAsync(long id, IUserContext users, IMetricContext db, HttpContext context)
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

    internal static async Task<IResult> SearchAsync(SearchMetric search, long? personId, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var type = await db.GetMetricType(search.Type);
        if (type is null)
        {
            return TypedResults.BadRequest("Wrong metric type");
        }

        if (search.Value is not null)
        {
            // search by value
            if (type.Type != (int)MetricDataType.Text)
            {
                return TypedResults.BadRequest("Search by value is only for text metrics");
            }
        }
        else if (search.MaxValue is not null || search.MinValue is not null)
        {
            if (type.Type != (int)MetricDataType.Number)
            {
                return TypedResults.BadRequest("Search over values is only for number metrics");
            }
        }
        else if (search.IsTrue is not null)
        {
            if (type.Type != (int)MetricDataType.Bool)
            {
                return TypedResults.BadRequest("Search over bool is only for bool metrics");
            }
        }
        else
        {
            return TypedResults.NotFound();
        }

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var results = await db.SearchMetricsAsync(id, search);
        return TypedResults.Ok(results.Select(x => new Metric()
        {
            Value = x.Value,
            Date = x.Date,
            Id = x.Id,
            Person = x.PersonId,
            SourceId = x.SourceId,
            Type = x.Type,
            Source = (FileTypes)x.Source,
            Tag = x.Tag,
            Unit = x.UnitObject.ToUnit(),
        }).ToArray());
    }
}