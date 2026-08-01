import 'dart:io' as io;

import 'package:file_selector/file_selector.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileService extends LocalService implements FileService {
  LocalFileService(super.account);
  static String path = 'files';

  @override
  Future<FileData?> getData(int id, int? person) async {
    final dir = await getApplicationSupportDirectory();
    final fileDir = await io.Directory('${dir.path}/$path').create();

    final file = io.File('${fileDir.path}/$id');
    var data = await file.readAsString();

    return FileData(type: '', data: data);
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
  Future<void> postFileData(int fileId, XFile file, int? person) async {
    final dir = await getApplicationSupportDirectory();
    final fileDir = await io.Directory('${dir.path}/$path').create();
    await file.saveTo('${fileDir.path}/$fileId');
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
