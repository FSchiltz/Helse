import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class AdminService {
  Future<UserCreationStats?> getUserStats();

  Future<EventCreationStats?> getEventStats(
    DateTime? start,
    DateTime? end,
  );

  Future<MetricCreationStats?> getMetricStats(
    DateTime? start,
    DateTime? end,
  );

  Future<List<JobResultInfo>> getJobs();
}
