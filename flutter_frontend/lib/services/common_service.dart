import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class CommonService {
  Future<List<Unit>> getUnits();
}
