import 'package:helse/di/dependencies.dart';
import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/settings_services.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalSettingService extends LocalService implements SettingService {
  LocalSettingService(super.account);

  @override
  Future<PatientsSettings> getPatientsSettings() async {
    return Dependencies.logics.patientsSettings.patientsSettings();
  }

  @override
  Future<UserSettings> getPersonSettings() async {
    return Dependencies.logics.settings.userSettings();
  }

  @override
  Future<Gotify> gotify() async => Gotify();

  @override
  Future<Oauth> oauth() async => Oauth();

  @override
  Future<Proxy> proxy() async => Proxy();

  @override
  Future<void> savePatientsSettings(PatientsSettings settings) async {}

  @override
  Future<void> savePersonSettings(UserSettings settings) async {}

  @override
  Future<Smtp> smtp() async => Smtp();

  @override
  Future<void> updateGotify(Gotify settings) async {}

  @override
  Future<void> updateOauth(Oauth settings) async {}

  @override
  Future<void> updateProxy(Proxy settings) async {}

  @override
  Future<void> updateSmtp(Smtp settings) async {}
}
