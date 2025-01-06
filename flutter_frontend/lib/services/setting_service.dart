import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class SettingService extends ApiService {
  SettingService(super.account);

  Future<Oauth> oauth() async {
    var api = await getService();
    return await call(api.apiAdminSettingsOauthGet) ?? const Oauth();
  }

  Future<void> updateOauth(Oauth settings) async {
    var api = await getService();
    await call(() => api.apiAdminSettingsOauthPost(body: settings));
  }

  Future<Proxy> proxy() async {
    var api = await getService();
    return await call(api.apiAdminSettingsProxyGet) ?? const Proxy();
  }

  Future<void> updateProxy(Proxy settings) async {
    var api = await getService();
    await call(() => api.apiAdminSettingsProxyPost(body: settings));
  }
}
