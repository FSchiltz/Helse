import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class MetricService extends ApiService {
  MetricService(super.account);

  Future<List<MetricType>?> metricsType(bool all) async {
    var api = await getService();
    return await call(() => api.apiMetricsTypeGet(all: all));
  }

  Future<void> addMetricsType(MetricType metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypePost(body: metric));
  }

  Future<void> updateMetricsType(MetricType metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypePut(body: metric));
  }

  Future<void> deleteMetricsType(int metric) async {
    var api = await getService();
    await call(() => api.apiMetricsTypeIdDelete(id: metric));
  }

  Future<List<Metric>?> metrics(int? type, DateTime? start, DateTime? end, {int? person, bool simple = false}) async {
    var api = await getService();
    if (simple) {
      return await call(() => api.apiMetricsSummaryGet(tile: 24, type: type, start: start?.toUtc(), end: end?.toUtc(), personId: person));
    } else {
      return await call(() => api.apiMetricsGet(type: type, start: start?.toUtc(), end: end?.toUtc(), personId: person));
    }
  }

  Future<void> addMetrics(CreateMetric metric, {int? person}) async {
    var api = await getService();
    await call(() => api.apiMetricsPost(body: metric, personId: person));
  }
}
