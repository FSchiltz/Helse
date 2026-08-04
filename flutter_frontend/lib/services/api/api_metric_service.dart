import 'package:helse/services/metric_service.dart';

import 'api_service.dart';
import '../swagger/generated_code/helseapi.swagger.dart';

class ApiMetricService extends ApiService implements MetricService{
  ApiMetricService(super.account);

  @override
  Future<List<MetricType>?> metricsType(bool all, int? group) async {
    final api = await getService();
    return await call(() => api.apiMetricsTypeGet(all: all, group: group));
  }

  @override
  Future<void> deleteMetric(int id) async {
    final api = await getService();
    await call(() => api.apiMetricsIdDelete(id: id));
  }

  @override
  Future<void> deleteMetrics(List<Metric> metrics, {int? person}) async {
    final api = await getService();
    await call(
      () => api.apiMetricsDeletePost(
        body: metrics.map((e) => e.id).toList(),
        person: person,
      ),
    );
  }

  @override
  Future<void> addMetricsType(CreateMetricType metric) async {
    final api = await getService();
    await call(() => api.apiMetricsTypePost(body: metric));
  }

  @override
  Future<void> updateMetricsType(UpdateMetricType metric) async {
    final api = await getService();
    await call(() => api.apiMetricsTypePut(body: metric));
  }

  @override
  Future<void> deleteMetricsType(int metric) async {
    final api = await getService();
    await call(() => api.apiMetricsTypeIdDelete(id: metric));
  }

  @override
  Future<List<Metric>?> searchMetrics(
    int? person,
    SearchMetric search,
    int page,
    int pageSize,
  ) async {
    final api = await getService();
    return await call(
      () => api.apiMetricsSearchPost(
        body: search,
        personId: person,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  @override
  Future<int?> countMetrics(int? person, SearchMetric search) async {
    final api = await getService();
    return await call(
      () => api.apiMetricsCountPost(body: search, personId: person),
    );
  }

  @override
  Future<List<Metric>> metrics(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
  }) async {
    final api = await getService();
    List<Metric>? metrics = await call(
      () => api.apiMetricsGet(
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );

    return metrics ?? [];
  }

  @override
  Future<MetricSummaries> metricSummaries(
    int type,
    DateTime start,
    DateTime end, {
    int? person,
    int? tile,
  }) async {
    final api = await getService();
    return await call(
          () => api.apiMetricsSummaryGet(
            tile: tile,
            type: type,
            start: start.toUtc(),
            end: end.toUtc(),
            personId: person,
          ),
        ) ??
        MetricSummaries(metrics: []);
  }

  @override
  Future<int?> addMetrics(CreateMetric metric, {int? person}) async {
    final api = await getService();
    return await call(() => api.apiMetricsPost(body: metric, personId: person));
  }

  @override
  Future<void> updateMetric(UpdateMetric metric) async {
    final api = await getService();
    await call(() => api.apiMetricsPut(body: metric));
  }

  @override
  Future<void> updateMetrics(PatchMetric patch, {int? person}) async {
    final api = await getService();
    await call(() => api.apiMetricsUpdatePut(body: patch, personId: person));
  }

  @override
  Future<void> addGroup(CreateGroup metric) async {
    final api = await getService();
    await call(() => api.apiMetricsGroupsPost(body: metric));
  }

  @override
  Future<void> updateGroup(UpdateGroup metric) async {
    final api = await getService();
    await call(() => api.apiMetricsGroupsPut(body: metric));
  }

  @override
  Future<void> deleteMetricsGroup(int metric) async {
    final api = await getService();
    await call(() => api.apiMetricsGroupsIdDelete(id: metric));
  }

  @override
  Future<List<Group>?> metricsGroup() async {
    final api = await getService();
    return await call(() => api.apiMetricsGroupsGet());
  }
}
