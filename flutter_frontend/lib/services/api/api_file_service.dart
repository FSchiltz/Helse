import 'package:file_selector/file_selector.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';

class ApiFileService extends ApiService implements FileService {
  ApiFileService(super.account);

  @override
  Future<List<File>> getMetricFiles(int id, int? person) async {
    final api = await getService();
    return await call(
          () => api.apiFilesMetricsMetricidGet(metricid: id, personId: person),
        ) ??
        [];
  }

  @override
  Future<List<File>> getEventFiles(int id, int? person) async {
    final api = await getService();
    return await call(
          () => api.apiFilesEventsEventidGet(eventid: id, personId: person),
        ) ??
        [];
  }

  @override
  Future<int?> postFile(UIFile file, int? person) async {
    final fileData = file.file;
    if (fileData == null) {
      return null;
    }

    final api = await getService();
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

  @override
  Future<void> linkMetric(int fileId, int metricId, int? person) async {
    final api = await getService();
    await call(
      () => api.apiFilesMetricsMetricidFileidPost(
        metricid: metricId,
        fileid: fileId,
        personId: person,
      ),
    );
  }

  @override
  Future<void> postFileData(int fileId, XFile file, int? person) async {
    final api = await getService();

    final part = await Dependencies.logics.files.extract(file);
    await call(
      () => api.apiFilesDataIdPost(id: fileId, file: part, personId: person),
    );
  }

  @override
  Future<void> unlinkMetric(int fileId, int metricId, int? person) async {
    final api = await getService();
    await call(
      () => api.apiFilesMetricsMetricidFileidDelete(
        metricid: metricId,
        fileid: fileId,
        personId: person,
      ),
    );
  }

  @override
  Future<FileData?> getData(int id, int? person) async {
    final api = await getService();
    return await call(() => api.apiFilesDataIdGet(id: id, personId: person));
  }

  @override
  Future<PaginatedOfFile?> getFiles(int? person) async {
    final api = await getService();
    return await call(
      () => api.apiFilesGet(personId: person, page: 0, pageSize: 100),
    );
  }

  @override
  Future<void> linkEvent(int fileId, int eventId, int? person) async {
    final api = await getService();
    await call(
      () => api.apiFilesEventsEventidFileidPost(
        eventid: eventId,
        fileid: fileId,
        personId: person,
      ),
    );
  }

  @override
  Future<void> unlinkEvent(int fileId, int eventId, int? person) async {
    final api = await getService();
    await call(
      () => api.apiFilesEventsEventidFileidDelete(
        eventid: eventId,
        fileid: fileId,
        personId: person,
      ),
    );
  }
}
