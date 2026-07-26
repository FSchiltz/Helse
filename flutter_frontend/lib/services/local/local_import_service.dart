import 'package:file_selector/file_selector.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalImportService extends LocalService implements ImportService {
  LocalImportService(super.account);

  @override
  Future<List<ImportType>?> fileTypes() {
    // TODO: implement fileTypes
    throw UnimplementedError();
  }

  @override
  Future<List<JobResultInfo>> getJobs() {
    // TODO: implement getJobs
    throw UnimplementedError();
  }

  @override
  Future<JobId?> import(XFile file, int type, int? patient) {
    // TODO: implement import
    throw UnimplementedError();
  }

  @override
  Future<ImportsResult?> importData(ImportData file) {
    // TODO: implement importData
    throw UnimplementedError();
  }

  @override
  Future<JobResult?> status(String id) {
    // TODO: implement status
    throw UnimplementedError();
  }
}
