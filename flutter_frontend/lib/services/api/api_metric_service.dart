import 'package:helse/services/api/cached_api_service.dart';
import 'package:helse/services/metric_service.dart';
import '../swagger/generated_code/helseapi.swagger.dart';

class ApiMetricService extends CachedApiService implements MetricService {
  ApiMetricService(super.account);

  @override
  Future<List<MetricType>?> metricsType(bool all, int? group) async {
    final api = await getService();
    final result = await call(
      () => api.apiMetricsTypeGet(all: all, group: group),
    );
    if (result != null) {
      await cache.saveMetricTypes(result);
    }
    return result;
  }

  @override
  Future<void> deleteMetric(int id) async {
    final api = await getService();
    final serverId = await cache.metricServerId(id);
    await call(() => api.apiMetricsIdDelete(id: serverId));
    await cache.removeMetric(serverId);
  }

  @override
  Future<void> deleteMetrics(List<Metric> metrics, {int? person}) async {
    final api = await getService();
    final ids = await Future.wait(
      metrics.map((metric) => cache.metricServerId(metric.id)),
    );
    await call(() => api.apiMetricsDeletePost(body: ids, person: person));
    for (final id in ids) {
      await cache.removeMetric(id);
    }
  }

  @override
  Future<int?> addMetricsType(CreateMetricType metric) async {
    final api = await getService();
    final id = await call(() => api.apiMetricsTypePost(body: metric));
    return createdId(id);
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
    final result = await call(
      () => api.apiMetricsSearchPost(
        body: search,
        personId: person,
        page: page,
        pageSize: pageSize,
      ),
    );
    if (result != null) {
      await cache.saveMetrics(result);
    }
    return result;
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

    final result = metrics ?? [];
    await cache.saveMetrics(result);
    return result;
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
    final result = await call(
      () => api.apiMetricsSummaryGet(
        tile: tile,
        type: type,
        start: start.toUtc(),
        end: end.toUtc(),
        personId: person,
      ),
    );
    final summaries = result ?? MetricSummaries(metrics: []);
    await cache.saveMetrics(summaries.metrics);
    return summaries;
  }

  @override
  Future<int?> addMetrics(CreateMetric metric, {int? person}) async {
    final api = await getService();
    return await call(() => api.apiMetricsPost(body: metric, personId: person));
  }

  @override
  Future<void> updateMetric(UpdateMetric metric) async {
    final api = await getService();
    final id = await cache.metricServerId(metric.id);
    await call(
      () => api.apiMetricsPut(
        body: UpdateMetric(
          id: id,
          unit: metric.unit,
          date: metric.date,
          value: metric.value,
          tag: metric.tag,
          type: metric.type,
          source: metric.source,
          sourceId: metric.sourceId,
        ),
      ),
    );
  }

  @override
  Future<void> updateMetrics(PatchMetric patch, {int? person}) async {
    final api = await getService();
    await call(() => api.apiMetricsUpdatePut(body: patch, personId: person));
  }

  @override
  Future<int?> addGroup(CreateGroup metric) async {
    final api = await getService();
    final id = await call(() => api.apiMetricsGroupsPost(body: metric));
    return createdId(id);
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
    final result = await call(() => api.apiMetricsGroupsGet());
    if (result != null) {
      await cache.saveGroups(result);
    }
    return result;
  }
}
