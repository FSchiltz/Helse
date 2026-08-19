import 'package:file_selector/file_selector.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/import_service.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiImportService extends ApiService implements ImportService {
  ApiImportService(super.account);

  @override
  Future<List<ImportType>?> fileTypes() async {
    final api = await getService();
    return await call(api.apiImportTypesGet);
  }

  @override
  Future<JobId?> import(XFile file, int type, int? patient) async {
    final api = await getService();

    final part = await Dependencies.logics.files.extract(file);
    return await call(
      () => api.apiImportTypePost(file: part, type: type, patient: patient),
    );
  }

  @override
  Future<JobResult?> status(String id) async {
    final api = await getService();

    return await call(() => api.apiImportIdGet(id: id));
  }

  @override
  Future<JobId?> importData(ImportData file) async {
    final api = await getService();
    return await call(() => api.apiImportListPost(body: file));
  }

  @override
  Future<List<JobResultInfo>> getJobs() async {
    final api = await getService();
    return await call(() => api.apiImportJobsGet()) ?? [];
  }

  @override
  Future<String?> export() {
    // TODO: add an export endpoint on the server side to get all the user data 
    throw UnimplementedError();
  }
}
