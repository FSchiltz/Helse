import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/account.dart';
import '../services/api_service.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class LocalSettings {
  static const _syncHealth = "syncHealth";
  bool syncHealth;

  LocalSettings(this.syncHealth);

  // stupid boilerplate code because dart can't decode json
  LocalSettings.fromJson(Map<String, dynamic> json) : syncHealth = json[_syncHealth] as bool;

  Map<String, dynamic> toJson() => {
        _syncHealth: syncHealth,
      };
}

class SettingsLogic {
  final storage = SharedPreferences.getInstance();
  final Account _account;
  static const _localKey = "localSettings";

  SettingsLogic(Account account) : _account = account;

  Future<Settings> getSettings() async {
    var settings = await ApiService(_account).getSettings();

    if (settings.oauth == null) const Settings(oauth: Oauth());
    return settings;
  }

  Future save(Settings settings) async {
    await ApiService(_account).saveSettings(settings);
  }

  Future<LocalSettings> getLocalSettings() async {
    var encoded = (await storage).getString(_localKey);
    if (encoded == null) {
      return LocalSettings(false);
    }

    return LocalSettings.fromJson(json.decode(encoded));
  }

  saveLocal(LocalSettings localSettings) async {
    await (await storage).setString(_localKey, json.encode(localSettings.toJson()));
  }
}
