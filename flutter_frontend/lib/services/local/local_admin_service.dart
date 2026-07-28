import 'package:helse/services/admin_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalAdminService extends LocalService implements AdminService {
  LocalAdminService(super.account);

  @override
  Future<EventCreationStats?> getEventStats(
    DateTime? start,
    DateTime? end,
  ) async {
    return null;
  }

  @override
  Future<List<JobResultInfo>> getJobs() async {
    return [];
  }

  @override
  Future<MetricCreationStats?> getMetricStats(
    DateTime? start,
    DateTime? end,
  ) async {
    return null;
  }

  @override
  Future<UserCreationStats?> getUserStats() async {
    return null;
  }
}
