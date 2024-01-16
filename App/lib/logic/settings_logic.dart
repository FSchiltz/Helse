import '../services/account.dart';
import '../services/api_service.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class SettingsLogic {
  final Account _account;

  SettingsLogic(Account account) : _account = account;

  Future<Settings> getSettings() async {
    var settings = await ApiService(_account).getSettings();

    if (settings.oauth == null) const Settings(oauth: Oauth());
    return settings;
  }

  Future save(Settings settings) async {
    await ApiService(_account).saveSettings(settings);
  }
}
