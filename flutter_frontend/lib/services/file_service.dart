import 'package:file_selector/file_selector.dart';
import 'package:helse/helpers/file_helper.dart';
import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/file_list_widget.dart';

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

  Future<int?> postFile(UIFile file, int? person) async {
    final fileData = file.file;
    if (fileData == null) {
      return null;
    }

    var api = await getService();
    return await call(
      () => api.apiFilesPost(
        body: CreateFile(
          dataType: fileData.mimeType ?? '',
          name: file.name,
          description: file.description,
          type: FileType.none,
          start: DateTime.now(),
        ),
        personId: person,
      ),
    );
  }

  Future<void> linkMetric(int? fileId, int metricId, int? person) async {
    var api = await getService();
    await call(
      () => api.apiFilesMetricsMetricidFileidPost(
        metricid: metricId,
        fileid: fileId,
        personId: person,
      ),
    );
  }

  Future<void> postFileData(int fileId, XFile file, int? person) async {
    var api = await getService();

    var part = FileHelper.extract(file);
    await call(
      () => api.apiFilesDataIdPost(id: fileId, file: part, personId: person),
    );
  }
}
