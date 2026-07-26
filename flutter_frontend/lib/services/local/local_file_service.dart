import 'package:cross_file/src/types/interface.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';

class LocalFileService extends LocalService implements FileService{
  LocalFileService(super.account);

  @override
  Future<FileData?> getData(int id, int? person) {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  Future<List<File>> getEventFiles(int id, int? person) {
    // TODO: implement getEventFiles
    throw UnimplementedError();
  }

  @override
  Future<PaginatedOfFile?> getFiles(int? person) {
    // TODO: implement getFiles
    throw UnimplementedError();
  }

  @override
  Future<List<File>> getMetricFiles(int id, int? person) {
    // TODO: implement getMetricFiles
    throw UnimplementedError();
  }

  @override
  Future<void> linkEvent(int fileId, int eventId, int? person) {
    // TODO: implement linkEvent
    throw UnimplementedError();
  }

  @override
  Future<void> linkMetric(int fileId, int metricId, int? person) {
    // TODO: implement linkMetric
    throw UnimplementedError();
  }

  @override
  Future<int?> postFile(UIFile file, int? person) {
    // TODO: implement postFile
    throw UnimplementedError();
  }

  @override
  Future<void> postFileData(int fileId, XFile file, int? person) {
    // TODO: implement postFileData
    throw UnimplementedError();
  }

  @override
  Future<void> unlinkEvent(int fileId, int eventId, int? person) {
    // TODO: implement unlinkEvent
    throw UnimplementedError();
  }

  @override
  Future<void> unlinkMetric(int fileId, int metricId, int? person) {
    // TODO: implement unlinkMetric
    throw UnimplementedError();
  }
}