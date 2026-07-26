import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class HelperService {
  Future<Status?> isInit(Uri url);
}
