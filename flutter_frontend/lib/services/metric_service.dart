import 'api_service.dart';
import 'swagger/generated_code/helseapi.swagger.dart';

class MetricService extends ApiService {
  MetricService(super.account);

  Future<List<MetricType>?> metricsType(bool all, int? group) async {
    var api = await getService();
    return await call(() => api.apiMetricsTypeGet(all: all, group: group));
  }

  Future<void> deleteMetrics(int id) async {
    var api = await getService();
    await call(() => api.apiMetricsIdDelete(id: id));
  }

  Future<void> addMetricsType(CreateMetricType metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypePost(body: metric));
  }

  Future<void> updateMetricsType(UpdateMetricType metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypePut(body: metric));
  }

  Future<void> deleteMetricsType(int metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypeIdDelete(id: metric));
  }

  Future<List<Metric>?> searchMetrics(int? person, SearchMetric search) async {
    var api = await getService();
    return await call(
      () => api.apiMetricsSearchPost(body: search, personId: person),
    );
  }

  Future<List<Metric>> metrics(
    int? type,
    DateTime? start,
    DateTime? end, {
    int? person,
    int? tile,
  }) async {
    var api = await getService();
    List<Metric>? metrics;
    if (tile != null) {
      metrics = await call(
        () => api.apiMetricsSummaryGet(
          tile: tile,
          type: type,
          start: start?.toUtc(),
          end: end?.toUtc(),
          personId: person,
        ),
      );
    } else {
      metrics = await call(
        () => api.apiMetricsGet(
          type: type,
          start: start?.toUtc(),
          end: end?.toUtc(),
          personId: person,
        ),
      );
    }

    return metrics ?? [];
  }

  Future<void> addMetrics(CreateMetric metric, {int? person}) async {
    var api = await getService();
    await call(() => api.apiMetricsPost(body: metric, personId: person));
  }

  Future<void> updateMetrics(UpdateMetric metric) async {
    var api = await getService();
    await call(() => api.apiMetricsPut(body: metric));
  }

  Future<void> addGroup(CreateGroup metric) async {
    var api = await getService();
    await call(() => api.apiMetricsGroupsPost(body: metric));
  }

  Future<void> updateGroup(UpdateGroup metric) async {
    var api = await getService();
    await call(() => api.apiMetricsGroupsPut(body: metric));
  }

  Future<void> deleteMetricsGroup(int metric) async {
    var api = await getService();
    await call(() => api.apiMetricsGroupsIdDelete(id: metric));
  }

  Future<List<Group>?> metricsGroup() async {
    var api = await getService();
    return await call(() => api.apiMetricsGroupsGet());
  }
}
