import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class CommonService extends ApiService {
  CommonService(super.account);

  Future<List<Unit>> getUnits() async {
    var api = await getService();
    return (await call(api.apiUnitsGet)) ?? [];
  }
}
