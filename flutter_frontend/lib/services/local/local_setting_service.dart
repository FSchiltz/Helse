import 'package:helse/services/local/local_service.dart';
import 'package:helse/services/settings_services.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class LocalSettingService extends LocalService implements SettingService {
  LocalSettingService(super.account);

  @override
  Future<PatientsSettings> getPatientsSettings() {
    // TODO: implement getPatientsSettings
    throw UnimplementedError();
  }

  @override
  Future<UserSettings> getPersonSettings() {
    // TODO: implement getPersonSettings
    throw UnimplementedError();
  }

  @override
  Future<Gotify> gotify() {
    // TODO: implement gotify
    throw UnimplementedError();
  }

  @override
  Future<Oauth> oauth() {
    // TODO: implement oauth
    throw UnimplementedError();
  }

  @override
  Future<Proxy> proxy() {
    // TODO: implement proxy
    throw UnimplementedError();
  }

  @override
  Future<void> savePatientsSettings(PatientsSettings settings) {
    // TODO: implement savePatientsSettings
    throw UnimplementedError();
  }

  @override
  Future<void> savePersonSettings(UserSettings settings) {
    // TODO: implement savePersonSettings
    throw UnimplementedError();
  }

  @override
  Future<Smtp> smtp() {
    // TODO: implement smtp
    throw UnimplementedError();
  }

  @override
  Future<void> updateGotify(Gotify settings) {
    // TODO: implement updateGotify
    throw UnimplementedError();
  }

  @override
  Future<void> updateOauth(Oauth settings) {
    // TODO: implement updateOauth
    throw UnimplementedError();
  }

  @override
  Future<void> updateProxy(Proxy settings) {
    // TODO: implement updateProxy
    throw UnimplementedError();
  }

  @override
  Future<void> updateSmtp(Smtp settings) {
    // TODO: implement updateSmtp
    throw UnimplementedError();
  }

}
