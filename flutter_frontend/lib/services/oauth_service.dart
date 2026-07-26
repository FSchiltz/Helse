import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class OauthService {
  Uri get redirectUrl;

  Future<String?> getGrant(String url, OauthConnection oauth);

  Future<String?> getCode(Map<String, String> uri);
}
