import 'package:helse/services/helper_service.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalHelperService extends LocalService implements HelperService {
  LocalHelperService(super.account);

  @override
  Future<Status?> isInit(Uri url) async {
    return Status(init: true, externalAuth: false, oauths: []);
  }
}
