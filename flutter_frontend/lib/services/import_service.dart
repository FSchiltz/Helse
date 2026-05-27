import 'package:helse/services/api_service.dart';
import 'package:http/http.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class ImportService extends ApiService {
  ImportService(super.account);

  Future<List<FileType>?> fileTypes() async {
    var api = await getService();
    return await call(api.apiImportTypesGet);
  }

  Future<String?> import(String file, int type) async {
    var api = await getService();

    var part = MultipartFile.fromString("file", file, filename: 'upload');
    return await call(() => api.apiImportTypePost(file: part, type: type));
  }

  Future<JobResult?> status(String id) async {
    var api = await getService();

    return await call(() => api.apiImportGet(id: id));
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
