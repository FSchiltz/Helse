import 'package:file_selector/file_selector.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class ImportService {
  Future<List<ImportType>?> fileTypes();

  Future<JobId?> import(
    XFile file,
    int type,
    int? patient,
  );

  Future<JobResult?> status(String id);

  Future<ImportsResult?> importData(ImportData file);

  Future<List<JobResultInfo>> getJobs();
}
