import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class HelperService extends ApiService {
  HelperService(super.account);

  Future<Status?> isInit(Uri url) async {
    var api = getApi(url, null);
    var response = await api.apiStatusGet();

    if (!response.isSuccessful) return null;

    return response.bodyOrThrow;
  }
}
