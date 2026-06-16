import 'api_service.dart';
import 'swagger/generated_code/helseapi.swagger.dart';

class AdminService extends ApiService {
  AdminService(super.account);

  Future<UserCreationStats?> getUserStats() async {
    var api = await getService();
    var response = await api.apiAdminStatsUsersGet();
    return response.body;
  }

  Future<EventCreationStats?> getEventStats(DateTime? start, DateTime? end) async {
    var api = await getService();
    var response = await api.apiAdminStatsEventsGet(start: start, end: end);
    return response.body;
  }

  Future<MetricCreationStats?> getmetricStats(DateTime? start, DateTime? end) async {
    var api = await getService();
    var response = await api.apiAdminStatsMetricsGet(start: start, end: end);
    return response.body;
  }

  Future<List<JobResultInfo>> getJobs() async {
    var api = await getService();
    return await call(() => api.apiImportJobsAllGet(), #getJobs) ?? [];
  }
}
