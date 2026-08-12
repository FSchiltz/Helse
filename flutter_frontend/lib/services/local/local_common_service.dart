import 'package:drift/drift.dart';
import 'package:helse/services/common_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalCommonService extends LocalService implements CommonService {
  @override
  Future<List<Unit>> getUnits() async {
    final result = await database.unit.select().get();
    final unitmap = UnitType.values.asNameMap();
    return result
        .map(
          (e) => Unit(
            type: unitmap[e.type]!,
            id: e.id,
            code: e.code,
          ),
        )
        .toList();
  }
}
