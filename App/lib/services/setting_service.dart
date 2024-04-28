import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class SettingService extends ApiService {
  SettingService(super.account);

    Future<Settings> getSettings() async {
    var api = await getService();
    return await call(api.apiAdminSettingsGet) ?? const Settings();
  }

  Future<void> saveSettings(Settings settings) async {
    var api = await getService();
    await call(() => api.apiAdminSettingsPost(body: settings));
  }
}
