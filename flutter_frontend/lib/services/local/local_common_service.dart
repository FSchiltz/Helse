import 'package:helse/services/common_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalCommonService extends  LocalService implements CommonService{
  LocalCommonService(super.account);

  @override
  Future<List<Unit>> getUnits() {
    // TODO: implement getUnits
    throw UnimplementedError();
  }
}
