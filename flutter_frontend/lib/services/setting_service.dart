import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/helseapi.swagger.dart';

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

  Future<Smtp> smtp() async {
    var api = await getService();
    return await call(api.apiAdminSettingsSmtpGet) ?? const Smtp();
  }

  Future<void> updateSmtp(Smtp settings) async {
    var api = await getService();
    await call(() => api.apiAdminSettingsSmtpPost(body: settings));
  }

  Future<Gotify> gotify() async {
    var api = await getService();
    return await call(api.apiAdminSettingsGotifyGet) ?? const Gotify();
  }

  Future<void> updateGotify(Gotify settings) async {
    var api = await getService();
    await call(() => api.apiAdminSettingsGotifyPost(body: settings));
  }
}
