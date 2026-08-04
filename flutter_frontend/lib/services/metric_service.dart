import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class MetricService {
  Future<List<MetricType>?> metricsType(
    bool all,
    int? group,
  );

  Future<void> addMetricsType(CreateMetricType metric);

  Future<void> updateMetricsType(UpdateMetricType metric);

  Future<void> deleteMetricsType(int metric);

  Future<List<Group>?> metricsGroup();

  Future<void> addGroup(CreateGroup group);

  Future<void> updateGroup(UpdateGroup group);

  Future<void> deleteMetricsGroup(int group);

  Future<List<Metric>> metrics(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  });

  Future<MetricSummaries> metricSummaries(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
    int? tile,
  });

  Future<int?> addMetrics(
    CreateMetric metric, {
    int? person,
  });

  Future<void> updateMetric(UpdateMetric metric);

  Future<void> deleteMetric(int id);

  Future<void> deleteMetrics(
    List<Metric> metrics, {
    int? person,
  });

  Future<List<Metric>?> searchMetrics(
    int? person,
    SearchMetric search,
    int page,
    int pageSize,
  );

  Future<int?> countMetrics(
    int? person,
    SearchMetric search,
  );

  Future<void> updateMetrics(
    PatchMetric patch, {
    int? person,
  });
}