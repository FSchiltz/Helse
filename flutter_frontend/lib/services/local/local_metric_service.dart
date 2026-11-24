import 'package:drift/drift.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalMetricService extends LocalService implements MetricService {
  LocalMetricService(super.account);

  @override
  Future<int?> addGroup(CreateGroup group) async {
    requireUserInitiatedOffline();
    final row = await database.group.insertReturning(
      GroupCompanion.insert(
        name: group.name,
        description: group.description,
        showOnDashboard: group.showOnDashboard ?? false,
        showTitle: group.showTitle ?? false,
        created: DateTime.now().toUtc(),
      ),
    );
    await markChanged();
    return row.id;
  }

  @override
  Future<int?> addMetrics(CreateMetric metric, {int? person}) async {
    final newRow = await database
        .into(database.metric)
        .insertReturning(
          MetricCompanion.insert(
            date: metric.date,
            type: metric.type,
            value: metric.value,
            person: person ?? 0,
            created: DateTime.now().toUtc(),
            source: metric.source!.name,
            sourceId: metric.sourceId,
          ),
        );

    await markChanged();
    return newRow.id;
  }

  @override
  Future<int?> addMetricsType(CreateMetricType metric) async {
    requireUserInitiatedOffline();
    final row = await database.metricType.insertReturning(
      MetricTypeCompanion.insert(
        name: metric.name,
        description: Value(metric.description),
        groupId: metric.groupId,
        timeDifference: Value(metric.timeDifference),
        visible: metric.visible ?? false,
        valueCount: Value(metric.valueCount),
        showOnDashboard: metric.showOnDashboard ?? false,
        userEditable: true,
        summaryType: metric.summaryType?.name ?? '',
        type: metric.type?.name ?? '',
        unit: metric.unit,
        created: DateTime.now().toUtc(),
      ),
    );
    await markChanged();
    return row.id;
  }

  @override
  Future<int?> countMetrics(int? person, SearchMetric search) async {
    var countExp = database.metric.id.count();

    final query = database.selectOnly(database.metric)..addColumns([countExp]);

    query.where(database.metric.type.equals(search.type));
    query.where(database.metric.person.equals(person ?? 0));

    if (search.from != null) {
      query.where(database.metric.date.isBiggerOrEqualValue(search.from!));
    }

    if (search.to != null) {
      query.where(database.metric.date.isSmallerOrEqualValue(search.to!));
    }

    if (search.value != null) {
      query.where(database.metric.value.equals(search.value!));
    }

    if (search.filterSource != null) {
      query.where(database.metric.source.equals(search.source!.name));
    }

    return await query.map((row) => row.read(countExp)).getSingle();
  }

  @override
  Future<void> deleteMetric(int id) async {
    final row = await (database.select(
      database.metric,
    )..where((metric) => metric.id.equals(id))).getSingleOrNull();
    if (row?.serverId case final serverId?) {
      await queueDeletion('metric', serverId);
    }
    await (database.metric.delete()..where((tbl) => tbl.id.equals(id))).go();
    await markChanged();
  }

  @override
  Future<void> deleteMetrics(List<Metric> metrics, {int? person}) async {
    for (final item in metrics) {
      final row =
          await (database.select(database.metric)..where(
                (metric) =>
                    metric.person.equals(person ?? 0) &
                    metric.id.equals(item.id),
              ))
              .getSingleOrNull();
      if (row?.serverId case final serverId?) {
        await queueDeletion('metric', serverId);
      }
    }
    await database.batch((batch) {
      for (var event in metrics) {
        batch.deleteWhere(
          database.metric,
          (tbl) => tbl.person.equals(person ?? 0) & tbl.id.equals(event.id),
        );
      }
    });
    await markChanged();
  }

  @override
  Future<void> deleteMetricsGroup(int metric) async {
    requireUserInitiatedOffline();
    final row = await (database.select(
      database.group,
    )..where((group) => group.id.equals(metric))).getSingleOrNull();
    await database.transaction(() async {
      await (database.group.delete()..where((group) => group.id.equals(metric)))
          .go();
      if (row?.serverId case final serverId?) {
        await queueDeletion('group', serverId);
      }
    });
    await markChanged();
  }

  @override
  Future<void> deleteMetricsType(int metric) async {
    requireUserInitiatedOffline();
    final row = await (database.select(
      database.metricType,
    )..where((type) => type.id.equals(metric))).getSingleOrNull();
    await database.transaction(() async {
      await (database.metricType.delete()
            ..where((type) => type.id.equals(metric)))
          .go();
      if (row?.serverId case final serverId?) {
        await queueDeletion('metricType', serverId);
      }
    });
    await markChanged();
  }

  @override
  Future<MetricSummaries> metricSummaries(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
    int? tile,
  }) async {
    final result = await metrics(type, start, end, person: person);
    return MetricSummaries(metrics: result);
  }

  @override
  Future<List<Metric>> metrics(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final query = database.metric.select()
      ..where((x) => x.type.equals(type))
      ..where((x) => x.date.isBiggerOrEqualValue(start))
      ..where((x) => x.date.isSmallerOrEqualValue(end));

    query.where((x) => x.person.equals(person ?? 0));

    final result = await query.get();
    return result.map(_mapMetric).toList();
  }

  @override
  Future<List<Group>?> metricsGroup() async {
    final result = await database.select(database.group).get();
    return result
        .map(
          (e) => Group(
            name: e.name,
            id: e.id,
            description: e.description,
            showOnDashboard: e.showOnDashboard,
            showTitle: e.showTitle,
          ),
        )
        .toList();
  }

  @override
  Future<List<MetricType>?> metricsType(bool all, int? group) async {
    final result = await database.select(database.metricType).join([
      innerJoin(
        database.unit,
        database.unit.id.equalsExp(database.metricType.unit),
      ),
    ]).get();

    final summarymap = MetricSummary.values.asNameMap();
    final datamap = MetricDataType.values.asNameMap();
    final unitmap = UnitType.values.asNameMap();
    return result.map((j) {
      final e = j.readTable(database.metricType);
      final u = j.readTable(database.unit);

      return MetricType(
        id: e.id,
        unit: Unit(
          type: unitmap[u.type]!,
          id: u.id,
          code: u.code,
          description: u.description,
        ),
        userEditable: e.userEditable,
        name: e.name,
        groupId: e.groupId,
        description: e.description,
        showOnDashboard: e.showOnDashboard,
        summaryType: summarymap[e.summaryType],
        timeDifference: e.timeDifference,
        valueCount: e.valueCount,
        visible: e.visible,
        type: datamap[e.type],
      );
    }).toList();
  }

  @override
  Future<List<Metric>?> searchMetrics(
    int? person,
    SearchMetric search,
    int page,
    int pageSize,
  ) async {
    final query = database.metric.select();

    query.where((x) => x.type.equals(search.type));
    query.where((x) => x.person.equals(person ?? 0));

    if (search.from != null) {
      query.where((x) => x.date.isBiggerOrEqualValue(search.from!));
    }

    if (search.to != null) {
      query.where((x) => x.date.isSmallerOrEqualValue(search.to!));
    }

    if (search.value != null) {
      query.where((x) => x.value.equals(search.value ?? ''));
    }

    if (search.filterSource != null) {
      query.where((x) => x.source.equals(search.source!.name));
    }

    query.limit(pageSize, offset: pageSize * page);
    final result = await query.get();
    return result.map(_mapMetric).toList();
  }

  @override
  Future<void> updateGroup(UpdateGroup metric) async {
    requireUserInitiatedOffline();
    final id = metric.id;
    if (id == null) {
      throw ArgumentError.value(
        metric.id,
        'id',
        Translation.current.groupIdRequired,
      );
    }
    await (database.group.update()..where((group) => group.id.equals(id)))
        .write(
          GroupCompanion(
            name: Value(metric.name),
            description: Value(metric.description),
            showOnDashboard: Value(metric.showOnDashboard ?? false),
            showTitle: Value(metric.showTitle ?? false),
            synced: const Value(false),
          ),
        );
    await markChanged();
  }

  @override
  Future<void> updateMetric(UpdateMetric metric) async {
    await (database.metric.update()..where((x) => x.id.equals(metric.id)))
        .write(
          MetricCompanion(
            date: Value(metric.date),
            type: Value(metric.type),
            value: Value(metric.value),
            tag: Value(metric.tag),
            unit: Value(metric.unit),
            source: Value(metric.source?.name ?? ImportTypes.none.name),
            sourceId: Value(metric.sourceId),
            synced: const Value(false),
          ),
        );
    await markChanged();
  }

  @override
  Future<void> updateMetrics(PatchMetric patch, {int? person}) async {
    final ids = patch.ids;
    if (ids == null || ids.isEmpty) {
      return;
    }

    final updated =
        await (database.metric.update()..where(
              (metric) =>
                  metric.id.isIn(ids) & metric.person.equals(person ?? 0),
            ))
            .write(
              MetricCompanion(
                date: patch.updateDate == true
                    ? Value(patch.date)
                    : const Value.absent(),
                value: patch.updateValue == true
                    ? Value(patch.value)
                    : const Value.absent(),
                tag: patch.updateTag == true
                    ? Value(patch.tag)
                    : const Value.absent(),
                sourceId: patch.updateSourceId == true
                    ? Value(patch.sourceId)
                    : const Value.absent(),
                source: patch.updateSourceId == true
                    ? Value(patch.source?.name ?? ImportTypes.none.name)
                    : const Value.absent(),
                synced: const Value(false),
              ),
            );

    if (updated > 0) {
      await markChanged();
    }
  }

  @override
  Future<void> updateMetricsType(UpdateMetricType metric) async {
    requireUserInitiatedOffline();
    await (database.metricType.update()
          ..where((type) => type.id.equals(metric.id)))
        .write(
          MetricTypeCompanion(
            name: Value(metric.name),
            description: Value(metric.description),
            groupId: Value(metric.groupId),
            timeDifference: Value(metric.timeDifference),
            visible: Value(metric.visible ?? false),
            valueCount: Value(metric.valueCount),
            showOnDashboard: Value(metric.showOnDashboard ?? false),
            summaryType: Value(metric.summaryType?.name ?? ''),
            type: Value(metric.type?.name ?? ''),
            unit: Value(metric.unit),
            synced: const Value(false),
          ),
        );
    await markChanged();
  }

  Metric _mapMetric(MetricData e) {
    return Metric(
      id: e.id,
      person: e.person,
      date: e.date,
      value: e.value,
      type: e.type,
      sourceId: e.sourceId,
    );
  }
}
