import 'api_service.dart';
import 'swagger/generated_code/helseapi.swagger.dart';

class AdminService extends ApiService {
  AdminService(super.account);

  Future<UserStats?> getUserStats() async {
    var api = await getService();
    var response = await api.apiAdminStatsUsersGet();
    return response.body;
  }

  Future<EventStats?> getEventStats(DateTime? start, DateTime? end) async {
    var api = await getService();
    var response = await api.apiAdminStatsEventsGet(start: start, end: end);
    return response.body;
  }

    Future<EventStats?> getmetricStats(DateTime? start, DateTime? end) async {
    var api = await getService();
    var response = await api.apiAdminStatsMetricsGet(start: start, end: end);
    return response.body;
  }
}