import 'package:helse/services/api_service.dart';
import 'package:http/http.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class ImportService extends ApiService {
  ImportService(super.account);

  Future<List<FileType>?> fileTypes() async {
    var api = await getService();
    return await call(api.apiImportTypesGet);
  }

  Future<JobId?> import(String file, int type, int? patient) async {
    var api = await getService();

    var part = MultipartFile.fromString("file", file, filename: 'upload');
    return await call(
      () => api.apiImportTypePost(file: part, type: type, patient: patient),
    );
  }

  Future<JobResult?> status(String id) async {
    var api = await getService();

    return await call(() => api.apiImportIdGet(id: id));
  }

  Future<void> importData(ImportData file) async {
    var api = await getService();
    await call(() => api.apiImportPost(body: file));
  }

  Future<List<JobResultInfo>> getJobs() async {
    var api = await getService();
    return await call(() => api.apiImportJobsGet()) ?? [];
  }
}
