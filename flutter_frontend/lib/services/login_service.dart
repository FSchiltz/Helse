import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class LoginService {
  Future<ConnectionResponse?> login(Connection connection);

  Future<Status?> isInit(Uri url);

  Uri get redirectUrl;

  Future<String?> getGrant(String url, OauthConnection oauth);

  Future<String?> getCode(Map<String, String> uri);
}
