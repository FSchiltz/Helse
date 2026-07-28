import 'package:drift/drift.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalMetricService extends LocalService implements MetricService {
  LocalMetricService(super.account);

  @override
  Future<void> addGroup(CreateGroup group) async {
    await account.database
        .into(account.database.group)
        .insert(
          GroupCompanion.insert(
            description: group.description,
            name: group.name,
            showOnDashboard: group.showOnDashboard ?? false,
            showTitle: group.showTitle ?? false,
            created: DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<int?> addMetrics(CreateMetric metric, {int? person}) async {
    final newRow = await account.database
        .into(account.database.metric)
        .insertReturning(
          MetricCompanion.insert(
            date: metric.date,
            type: metric.type,
            value: metric.value,
            person: Value(person),
            created: DateTime.now().toUtc(),
          ),
        );

    return newRow.id;
  }

  @override
  Future<void> addMetricsType(CreateMetricType metric) async {
    await account.database
        .into(account.database.metricType)
        .insert(
          MetricTypeCompanion.insert(
            groupId: metric.groupId,
            name: metric.name,
            description: Value(metric.description),
            created: DateTime.now().toUtc(),
            showOnDashboard: metric.showOnDashboard ?? false,
            summaryType: metric.summaryType?.name ?? '',
            timeDifference: Value(metric.timeDifference),
            type: metric.type?.name ?? '',
            unit: metric.unit,
            userEditable: false,
            visible: metric.visible ?? false,
            valueCount: Value(metric.valueCount),
          ),
        );
  }

  @override
  Future<int?> countMetrics(int? person, SearchMetric search) {
    // TODO: implement countMetrics
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMetric(int id) {
    // TODO: implement deleteMetric
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMetrics(List<Metric> metrics, {int? person}) {
    // TODO: implement deleteMetrics
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMetricsGroup(int metric) {
    // TODO: implement deleteMetricsGroup
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMetricsType(int metric) {
    // TODO: implement deleteMetricsType
    throw UnimplementedError();
  }

  @override
  Future<MetricSummaries> metricSummaries(
    int? type,
    DateTime? start,
    DateTime? end, {
    int? person,
    int? tile,
  }) {
    // TODO: implement metricSummaries
    throw UnimplementedError();
  }

  @override
  Future<List<Metric>> metrics(
    int? type,
    DateTime? start,
    DateTime? end, {
    int? person,
  }) {
    // TODO: implement metrics
    throw UnimplementedError();
  }

  @override
  Future<List<Group>?> metricsGroup() async {
    final result = await account.database.select(account.database.group).get();
    return result
        .map(
          (e) => Group(
            name: e.name,
            description: e.description,
            showOnDashboard: e.showOnDashboard,
            showTitle: e.showTitle,
          ),
        )
        .toList();
  }

  @override
  Future<List<MetricType>?> metricsType(bool all, int? group) async {
    final result =
        await account.database.select(account.database.metricType).join([
          innerJoin(
            account.database.unit,
            account.database.unit.id.equalsExp(
              account.database.metricType.unit,
            ),
          ),
        ]).get();

    final summarymap = MetricSummary.values.asNameMap();
    final datamap = MetricDataType.values.asNameMap();
    final unitmap = UnitType.values.asNameMap();
    return result.map((j) {
      final e = j.readTable(account.database.metricType);
      final u = j.readTable(account.database.unit);

      return MetricType(
        id: e.id,
        unit: Unit(type: unitmap[u.type]!, id: u.id, code: u.code),
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
  ) {
    // TODO: implement searchMetrics
    throw UnimplementedError();
  }

  @override
  Future<void> updateGroup(UpdateGroup metric) {
    // TODO: implement updateGroup
    throw UnimplementedError();
  }

  @override
  Future<void> updateMetric(UpdateMetric metric) {
    // TODO: implement updateMetric
    throw UnimplementedError();
  }

  @override
  Future<void> updateMetrics(PatchMetric patch, {int? person}) {
    // TODO: implement updateMetrics
    throw UnimplementedError();
  }

  @override
  Future<void> updateMetricsType(UpdateMetricType metric) {
    // TODO: implement updateMetricsType
    throw UnimplementedError();
  }
}
