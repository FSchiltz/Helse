import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class FileService extends ApiService {
  FileService(super.account);

  Future<List<File>> getMetricFiles(int id, int? person) async {
    var api = await getService();
    return await call(
          () => api.apiFilesMetricsMetricidGet(metricid: id, personId: person),
        ) ??
        [];
  }

  Future<List<File>> getEventFiles(int id, int? person) async {
    var api = await getService();
    return await call(
          () => api.apiFilesEventsEventidGet(eventid: id, personId: person),
        ) ??
        [];
  }
}
