import 'package:helse/services/api_service.dart';
import 'package:http/http.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class HelperService extends ApiService {
  HelperService(super.account);

  Future<List<FileType>?> fileTypes() async {
    var api = await getService();
    return await call(api.apiImportTypesGet);
  }

  Future<void> import(String file, int type) async {
    var api = await getService();

    var part = MultipartFile.fromString("file", file, filename: 'upload');
    await call(() => api.apiImportTypePost(file: part, type: type));
  }

  Future<void> importData(ImportData file) async {
    var api = await getService();
    await call(() => api.apiImportPost(body: file));
  }

  Future<Status?> isInit(String url) async {
    var api = await getService(override: url);
    var response = await api.apiStatusGet();

    if (!response.isSuccessful) return null;

    return response.bodyOrThrow;
  }
}
