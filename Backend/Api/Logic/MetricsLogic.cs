using System.Net;
using Helse.Api.Data;
using Helse.Api.Data.Models.Common;
using Helse.Api.Helpers;
using Helse.Api.Mappers;
using Helse.Models.Common;
using Helse.Models.Imports;
using Helse.Models.Metrics;
using Helse.Models.Persons;
using LinqToDB;
using Microsoft.AspNetCore.Mvc;

namespace Helse.Api.Logic;

/// <summary>
/// Logic over the management of the metrics
/// </summary>
internal static class MetricsLogic
{
    public static RouteGroupBuilder MapMetrics(this RouteGroupBuilder api)
    {
        /* Metrics endpoints*/
        var metrics = api.MapGroup("/metrics").RequireAuthorization();
        metrics.MapGet("/summary", GetSummaryAsync)
        .Produces<MetricSummaries>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapGet("/", GetAsync)
        .Produces<Metric[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/", CreateAsync)
        .Produces<long>((int)HttpStatusCode.Created)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPut("/", UpdateAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapDelete("/{id}", DeleteAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPut("/update", UpdateBulkAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/delete", DeleteBulkAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/search", SearchAsync)
        .Produces<Metric[]>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        metrics.MapPost("/count", CountAsync)
        .Produces<long>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        var metricsType = metrics.MapGroup("/type").RequireAuthorization();
        metricsType.MapPost("/", MetricsLogic.CreateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapPut("/", UpdateTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapDelete("/{id}", DeleteTypeAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsType.MapGet("/", GetTypeAsync)
        .Produces<List<MetricType>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        var metricsGroup = metrics.MapGroup("/groups").RequireAuthorization();
        metricsGroup.MapPost("/", CreateGroupAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsGroup.MapPut("/", UpdateGroupAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsGroup.MapDelete("/{id}", DeleteGroupAsync)
        .Produces((int)HttpStatusCode.NoContent)
        .Produces((int)HttpStatusCode.Unauthorized);

        metricsGroup.MapGet("/", GetGroupsAsync)
        .Produces<List<Group>>((int)HttpStatusCode.OK)
        .Produces((int)HttpStatusCode.Unauthorized);

        return api;
    }

    public async static Task<IResult> GetAsync(int type, DateTime start, DateTime end, long? personId, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;
        var metrics = await db.GetMetrics(id, type, start, end);

        return TypedResults.Ok(metrics.Select(MetricMapper.Map));
    }

    public async static Task<IResult> GetSummaryAsync(int tile, int type, DateTime start, DateTime end, long? personId, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        long count = 0;
        var id = personId ?? user.PersonId;
        var metricType = await db.GetMetricType(type) ?? throw new InvalidDataException("Incorrect metric type: " + type);

        Data.Models.Health.Metric[] metrics;
        if (metricType.Type == (long)MetricDataType.Text)
        {
            count = await db.CountMetricsAsync(id, new SearchMetric
            {
                Type = type,
                From = start,
                To = end,
            });

            metrics = await db.GetLastMetrics(id, 3, type, start, end);
        }
        else
        {
            // TODO take into account metric that have a different unit than the parent
            metrics = await db.GetSummaryMetrics(tile, id, type, (MetricSummary)metricType.SummaryType, start, end);
        }

        return TypedResults.Ok(new MetricSummaries
        {
            Metrics = [.. metrics.Select(x => new Metric
            {
                Value = x.Value,
                Date = x.Date,
                Id = x.Id,
                Person = user.PersonId,
                Type = x.Type,
                Tag = x.Tag,
                User = x.UserId,
                Source = (ImportTypes)x.Source,
                SourceId = x.SourceId,
            })],
            Count = count,
        });
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

        var id = await db.Insert(metric, personId ?? user.PersonId, user.Id);

        return TypedResults.Created(default(Uri), id);
    }

    private static void Validate(CreateMetric metric, Units? unit, Data.Models.Health.MetricType? type)
    {
        if (type == null)
            throw new InvalidDataException("Type not found");

        if ((MetricDataType)type.Type == MetricDataType.Number && !double.TryParse(metric.Value, out var _))
            throw new InvalidDataException("The metric value is not a number");

        if ((MetricDataType)type.Type == MetricDataType.NumberRange)
        {
            var split = metric.Value.Split(';');
            if (split.Length < type.ValueCount)
            {
                throw new InvalidDataException($"The metric should have at least {type.ValueCount} value separated by a ';'");
            }

            if (split.Any(x => !double.TryParse(x, out var _)))
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

    public async static Task<IResult> DeleteAsync(long id, long? personId, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();

        await db.DeleteMetric(id, personId ?? user.PersonId);


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
        GroupId = x.GroupId,
        ValueCount = x.ValueCount,
        TimeDifference = x.TimeDifference,
    }));

    public static async Task<IResult> CreateTypeAsync(CreateMetricType metric, IUserContext users, IMetricContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        Validate(metric);

        await db.Insert(metric);

        return TypedResults.NoContent();
    }

    private static void Validate(CreateMetricType metric)
    {
        if (metric.Type != MetricDataType.Number && metric.SummaryType != MetricSummary.Latest)
        {
            throw new InvalidDataException("Only number can be have different summary than text");
        }

        if (metric.Type == MetricDataType.NumberRange && metric.ValueCount < 2)
        {
            throw new InvalidDataException("Number range needs at least 2 values");
        }
    }

    public static async Task<IResult> UpdateTypeAsync(UpdateMetricType metric, IUserContext users, IMetricContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;


        Validate(metric);

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

    public static async Task<IResult> GetGroupsAsync(IMetricContext db) => TypedResults.Ok((await db.GetMetricGroups()).Select(metric => new Group
    {
        Name = metric.Name,
        Description = metric.Description,
        ShowOnDashboard = metric.ShowOnDashboard,
        ShowTitle = metric.ShowTitle,
        Id = metric.Id,
    }));

    public async static Task<IResult> DeleteBulkAsync([FromBody] long[] ids, long? person, IUserContext users, IMetricContext events, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;


        person ??= user.PersonId;
        if (user.PersonId != person && !await users.ValidateCaregiverAsync(user, person.Value, RightType.Edit))
            return TypedResults.Forbid();

        await events.DeleteMetrics(ids, person.Value);


        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateBulkAsync(PatchMetric metric, long? personId, IUserContext users, IMetricContext metrics, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        personId ??= user.PersonId;

        if (personId != user.PersonId && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.Edit))
            return TypedResults.Forbid();
        var type = await metrics.GetMetricType((int)metric.Type);
        Validate(metric, null, type);
        await metrics.UpdateBulk(metric, personId.Value);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> CreateGroupAsync(CreateGroup metric, IUserContext users, IMetricContext db, HttpContext context)
    {
        var admin = await users.IsAdmin(context.User);
        if (admin is not null)
            return admin;

        await db.Insert(metric);

        return TypedResults.NoContent();
    }

    public static async Task<IResult> UpdateGroupAsync(UpdateGroup metric, IUserContext users, IMetricContext db, HttpContext context)
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

    internal static async Task<IResult> SearchAsync(SearchMetric search, long? personId, [AsParameters] Pagination pagination, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var type = await db.GetMetricType(search.Type);
        if (type is null)
        {
            return TypedResults.BadRequest("Wrong metric type");
        }

        var validation = Validate(search, type);
        if (validation is not null)
        {
            return validation;
        }

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var results = await db.SearchMetricsAsync(id, search, pagination);
        return TypedResults.Ok(results.Select(MetricMapper.Map));
    }

    internal static async Task<IResult> CountAsync(SearchMetric search, long? personId, IUserContext users, IMetricContext db, HttpContext context)
    {
        var (error, user) = await users.GetUser(context.User);
        if (error is not null)
            return error;

        var type = await db.GetMetricType(search.Type);
        if (type is null)
        {
            return TypedResults.BadRequest("Wrong metric type");
        }

        var validation = Validate(search, type);
        if (validation is not null)
        {
            return validation;
        }

        if (personId is not null && !await users.ValidateCaregiverAsync(user, personId.Value, RightType.View))
            return TypedResults.Forbid();

        var id = personId ?? user.PersonId;

        var results = await db.CountMetricsAsync(id, search);
        return TypedResults.Ok(results);
    }

    private static IResult? Validate(SearchMetric search, Data.Models.Health.MetricType type)
    {
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

        return null;
    }
}