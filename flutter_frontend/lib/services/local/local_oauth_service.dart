import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/oauth_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalOauthService extends LocalService implements OauthService {
  LocalOauthService(super.account);

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
}
