import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

abstract interface class SettingService {
  Future<Oauth> oauth();
  Future<void> updateOauth(Oauth settings);

  Future<Proxy> proxy();
  Future<void> updateProxy(Proxy settings);

  Future<Smtp> smtp();
  Future<void> updateSmtp(Smtp settings);

  Future<Gotify> gotify();
  Future<void> updateGotify(Gotify settings);

  Future<UserSettings> getPersonSettings();
  Future<void> savePersonSettings(UserSettings settings);

  Future<PatientsSettings> getPatientsSettings();
  Future<void> savePatientsSettings(PatientsSettings settings);
}
