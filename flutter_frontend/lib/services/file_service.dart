import 'package:file_selector/file_selector.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';

abstract interface class FileService {
  Future<List<File>> getMetricFiles(
    int id,
    int? person,
  );

  Future<List<File>> getEventFiles(
    int id,
    int? person,
  );

  Future<int?> postFile(
    UIFile file,
    int? person,
  );

  Future<void> postFileData(
    int fileId,
    XFile file,
    int? person,
  );

  Future<FileData?> getData(
    int id,
    int? person,
  );

  Future<PaginatedOfFile?> getFiles(
    int? person,
  );

  Future<void> linkMetric(
    int fileId,
    int metricId,
    int? person,
  );

  Future<void> unlinkMetric(
    int fileId,
    int metricId,
    int? person,
  );

  Future<void> linkEvent(
    int fileId,
    int eventId,
    int? person,
  );

  Future<void> unlinkEvent(
    int fileId,
    int eventId,
    int? person,
  );
}