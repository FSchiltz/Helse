import 'package:helse/services/admin_service.dart';

import 'api_service.dart';
import '../swagger/generated_code/helseapi.swagger.dart';

class ApiAdminService extends ApiService implements AdminService {
  ApiAdminService(super.account);

  @override
  Future<UserCreationStats?> getUserStats() async {
    final api = await getService();
    return call(api.apiAdminStatsUsersGet);
  }

  @override
  Future<EventCreationStats?> getEventStats(
    DateTime? start,
    DateTime? end,
  ) async {
    final api = await getService();
    return call(() => api.apiAdminStatsEventsGet(start: start, end: end));
  }

  @override
  Future<MetricCreationStats?> getMetricStats(
    DateTime? start,
    DateTime? end,
  ) async {
    final api = await getService();
    return call(() => api.apiAdminStatsMetricsGet(start: start, end: end));
  }

  @override
  Future<List<JobResultInfo>> getJobs() async {
    final api = await getService();
    return await call(() => api.apiImportJobsAllGet()) ?? [];
  }
}
