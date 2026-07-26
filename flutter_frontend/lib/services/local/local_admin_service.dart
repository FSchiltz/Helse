import 'package:helse/services/admin_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalAdminService extends LocalService implements AdminService {
  LocalAdminService(super.account);

  @override
  Future<EventCreationStats?> getEventStats(DateTime? start, DateTime? end) {
    // TODO: implement getEventStats
    throw UnimplementedError();
  }

  @override
  Future<List<JobResultInfo>> getJobs() {
    // TODO: implement getJobs
    throw UnimplementedError();
  }

  @override
  Future<MetricCreationStats?> getMetricStats(DateTime? start, DateTime? end) {
    // TODO: implement getMetricStats
    throw UnimplementedError();
  }

  @override
  Future<UserCreationStats?> getUserStats() {
    // TODO: implement getUserStats
    throw UnimplementedError();
  }
}
