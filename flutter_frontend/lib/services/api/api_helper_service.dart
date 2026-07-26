import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/helper_service.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiHelperService extends ApiService implements HelperService {
  ApiHelperService(super.account);

  @override
  Future<Status?> isInit(Uri url) async {
    final api = getApi(url, null);
    final response = await api.apiStatusGet();

    if (!response.isSuccessful) return null;

    return response.bodyOrThrow;
  }
}
