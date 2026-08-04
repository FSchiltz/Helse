import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/common_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ApiCommonService extends ApiService implements CommonService{
  ApiCommonService(super.account);

  @override
  Future<List<Unit>> getUnits() async {
    var api = await getService();
    return (await call(api.apiUnitsGet)) ?? [];
  }
}
