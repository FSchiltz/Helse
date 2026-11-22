import 'package:helse/services/api/cached_api_service.dart';
import 'package:helse/services/common_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ApiCommonService extends CachedApiService implements CommonService {
  ApiCommonService(super.account);

  @override
  Future<List<Unit>> getUnits() async {
    var api = await getService();
    final result = await call(api.apiUnitsGet) ?? [];
    await cache.saveUnits(result);
    return result;
  }
}
