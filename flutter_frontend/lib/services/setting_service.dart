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

  Future<void> savePersonSettings(UserSettings settings) async {
    var api = await getService();
    // swagger generate the wrong type so we have to make sure there is no null there
    if (settings.datePreset == null) {
      settings = settings.copyWith(datePreset: DatePreset.today);
    }

    if (settings.theme == null) {
      settings = settings.copyWith(theme: InterfaceTheme.system);
    }

    if (settings.eventWidth == null) {
      settings = settings.copyWith(eventWidth: 0);
    }

    await call(() => api.apiPersonSettingsPost(body: settings));
  }

  Future<UserSettings> getPersonSettings() async {
    var api = await getService();
    return await call(api.apiPersonSettingsGet) ?? const UserSettings();
  }

  Future<void> savePatientsSettings(PatientsSettings settings) async {
    var api = await getService();

    // swagger generate the wrong type so we have to make sure there is no null there
    var common = settings.$default;
    if (common != null) {
      if (common.datePreset == null) {
        common = common.copyWith(datePreset: DatePreset.today);
      }

      if (common.theme == null) {
        common = common.copyWith(theme: InterfaceTheme.system);
      }

      if (common.eventWidth == null) {
        common = common.copyWith(eventWidth: 0);
      }
      settings = settings.copyWith($default: common);
    }

    var patients = settings.patients;
    if (patients != null && patients.isNotEmpty) {
      List<PatientSettings> fixed = [];
      for (var item in patients) {
        if (item.datePreset == null) {
          item = item.copyWith(datePreset: DatePreset.today);
        }

        if (item.theme == null) {
          item = item.copyWith(theme: InterfaceTheme.system);
        }

        if (item.eventWidth == null) {
          item = item.copyWith(eventWidth: 0);
        }
        fixed.add(item);
      }
      settings = settings.copyWith(patients: fixed);
    }

    await call(() => api.apiPatientsSettingsPost(body: settings));
  }

  Future<PatientsSettings> getPatientsSettings() async {
    var api = await getService();
    return await call(api.apiPatientsSettingsGet) ?? const PatientsSettings();
  }
}
