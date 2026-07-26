import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/oauth_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalOauthService extends LocalService implements OauthService {
  LocalOauthService(super.account);

  @override
  Future<String?> getCode(Map<String, String> uri) {
    // TODO: implement getCode
    throw UnimplementedError();
  }

  @override
  Future<String?> getGrant(String url, OauthConnection oauth) {
    // TODO: implement getGrant
    throw UnimplementedError();
  }

  @override
  // TODO: implement redirectUrl
  Uri get redirectUrl => throw UnimplementedError();
}
