import 'package:helse/services/common_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalCommonService extends LocalService implements CommonService {
  LocalCommonService(super.account);

  @override
  Future<List<Unit>> getUnits() async {
    final result = await account.database.select(account.database.unit).get();
    return result
        .map(
          (e) => Unit(
            type: UnitType.values.asNameMap()[e.code]!,
            id: e.id,
            code: e.code,
          ),
        )
        .toList();
  }
}
