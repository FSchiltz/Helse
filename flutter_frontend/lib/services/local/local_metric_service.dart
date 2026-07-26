import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/metric_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalMetricService extends LocalService implements MetricService {
  LocalMetricService(super.account);

  @override
  Future<void> addGroup(CreateGroup metric) {
    // TODO: implement addGroup
    throw UnimplementedError();
  }

  @override
  Future<int?> addMetrics(CreateMetric metric, {int? person}) {
    // TODO: implement addMetrics
    throw UnimplementedError();
  }

  @override
  Future<void> addMetricsType(CreateMetricType metric) {
    // TODO: implement addMetricsType
    throw UnimplementedError();
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
  Future<MetricSummaries> metricSummaries(int? type, DateTime? start, DateTime? end, {int? person, int? tile}) {
    // TODO: implement metricSummaries
    throw UnimplementedError();
  }

  @override
  Future<List<Metric>> metrics(int? type, DateTime? start, DateTime? end, {int? person}) {
    // TODO: implement metrics
    throw UnimplementedError();
  }

  @override
  Future<List<Group>?> metricsGroup() {
    // TODO: implement metricsGroup
    throw UnimplementedError();
  }

  @override
  Future<List<MetricType>?> metricsType(bool all, int? group) {
    // TODO: implement metricsType
    throw UnimplementedError();
  }

  @override
  Future<List<Metric>?> searchMetrics(int? person, SearchMetric search, int page, int pageSize) {
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
