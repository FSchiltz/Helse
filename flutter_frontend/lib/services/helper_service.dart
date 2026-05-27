import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

class HelperService extends ApiService {
  HelperService(super.account);

  Future<Status?> isInit(String url) async {
    var api = await getService(override: url);
    var response = await api.apiStatusGet();

    if (!response.isSuccessful) return null;

    return response.bodyOrThrow;
  }
}
