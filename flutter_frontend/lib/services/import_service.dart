import 'package:file_selector/file_selector.dart';
import 'package:helse/helpers/file_helper.dart';
import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class ImportService extends ApiService {
  ImportService(super.account);

  Future<List<ImportType>?> fileTypes() async {
    var api = await getService();
    return await call(api.apiImportTypesGet);
  }

  Future<JobId?> import(XFile file, int type, int? patient) async {
    var api = await getService();

    var part = await FileHelper.extract(file);
    return await call(
      () => api.apiImportTypePost(file: part, type: type, patient: patient),
    );
  }

  Future<JobResult?> status(String id) async {
    var api = await getService();

    return await call(() => api.apiImportIdGet(id: id));
  }

  Future<ImportsResult?> importData(ImportData file) async {
    var api = await getService();
    return await call(() => api.apiImportResultsPost(body: file));
  }

  Future<List<JobResultInfo>> getJobs() async {
    var api = await getService();
    return await call(() => api.apiImportJobsGet()) ?? [];
  }
}
