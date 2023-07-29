import '../../services/account.dart';
import '../../services/api_service.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';

class MetricsLogic {
  final Account _account;

  MetricsLogic(Account account): _account = account;

  Future<List<MetricType>> getType() async {
    return (await ApiService(_account).metricsType()) ?? List<MetricType>.empty();
  }

  Future<List<Metric>> getMetric(int type, DateTime start, DateTime end) async {
    return (await ApiService(_account).metrics(type, start.toUtc().toString(), end.toUtc().toString())) ?? List<Metric>.empty();
  }

  Future<void> addMetric(CreateMetric metric) {
    return ApiService(_account).addMetrics(metric);
  }
}
