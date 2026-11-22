import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalLoginService extends LocalService implements LoginService {
  LocalLoginService(super.account);

  @override
  Future<ConnectionResponse?> login(Connection connection) async {
    // TODO sync the correct user type from the server to allow for full sync
    return ConnectionResponse(
      accessToken: '',
      roles: [
        UserType.patient,
        UserType.caregiver,
        UserType.user,
        UserType.admin,
      ],
      refreshToken: '',
    );
  }

  @override
  Future<String?> getCode(Map<String, String> uri) async {
    return '';
  }

  @override
  Future<String?> getGrant(String url, OauthConnection oauth) async {
    return '';
  }

  @override
  Uri get redirectUrl => Uri.base;

  @override
  Future<Status?> isInit(Uri url) async {
    return Status(init: true, externalAuth: false, oauths: []);
  }
}
