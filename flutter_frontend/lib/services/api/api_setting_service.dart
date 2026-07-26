import 'package:helse/helpers/user_settings_extensions.dart';
import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/settings_services.dart';

import '../swagger/generated_code/helseapi.swagger.dart';

class ApiSettingService extends ApiService implements SettingService{
  ApiSettingService(super.account);

  @override
  Future<Oauth> oauth() async {
    final api = await getService();
    return await call(api.apiAdminSettingsOauthGet) ?? const Oauth();
  }

  @override
  Future<void> updateOauth(Oauth settings) async {
    final api = await getService();
    await call(() => api.apiAdminSettingsOauthPost(body: settings));
  }

  @override
  Future<Proxy> proxy() async {
    final api = await getService();
    return await call(api.apiAdminSettingsProxyGet) ?? const Proxy();
  }

  @override
  Future<void> updateProxy(Proxy settings) async {
    final api = await getService();
    await call(() => api.apiAdminSettingsProxyPost(body: settings));
  }

  @override
  Future<Smtp> smtp() async {
    final api = await getService();
    return await call(api.apiAdminSettingsSmtpGet) ?? const Smtp();
  }

  @override
  Future<void> updateSmtp(Smtp settings) async {
    final api = await getService();
    await call(() => api.apiAdminSettingsSmtpPost(body: settings));
  }

  @override
  Future<Gotify> gotify() async {
    final api = await getService();
    return await call(api.apiAdminSettingsGotifyGet) ?? const Gotify();
  }

  @override
  Future<void> updateGotify(Gotify settings) async {
    final api = await getService();
    await call(() => api.apiAdminSettingsGotifyPost(body: settings));
  }

  @override
  Future<void> savePersonSettings(UserSettings settings) async {
    final api = await getService();
    await call(() => api.apiPersonSettingsPost(body: settings.normalized()));
  }

  @override
  Future<UserSettings> getPersonSettings() async {
    final api = await getService();
    return await call(api.apiPersonSettingsGet) ?? const UserSettings();
  }

  @override
  Future<void> savePatientsSettings(PatientsSettings settings) async {
    final api = await getService();

    // swagger generate the wrong type so we have to make sure there is no null there
    final common = settings.$default;
    if (common != null) {
      settings = settings.copyWith($default: common.normalized());
    }

    final patients = settings.patients;
    if (patients != null) {
      settings = settings.copyWith(
        patients: patients.map((p) => p.normalized()).toList(),
      );
    }

    await call(() => api.apiPatientsSettingsPost(body: settings));
  }

  @override
  Future<PatientsSettings> getPatientsSettings() async {
    final api = await getService();
    return await call(api.apiPatientsSettingsGet) ?? const PatientsSettings();
  }
}
