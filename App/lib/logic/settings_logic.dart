import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/account.dart';
import '../services/setting_service.dart';
import '../services/swagger/generated_code/swagger.swagger.dart';

class LocalSettings {
  static const _syncHealth = "syncHealth";
  bool syncHealth;

  static const _theme = "theme";
  ThemeMode theme;

  LocalSettings(this.syncHealth, this.theme);

  // stupid boilerplate code because dart can't decode json
  LocalSettings.fromJson(Map<String, dynamic> json)
      : syncHealth = json[_syncHealth] as bool,
        theme =  ThemeMode.values.firstWhere((e) => e.name == json[_theme]);

  Map<String, dynamic> toJson() => {
        _syncHealth: syncHealth,
        _theme: theme.name,
      };
}

class SettingsLogic {
  final storage = SharedPreferences.getInstance();
  final Account _account;
  static const _localKey = "localSettings";

  SettingsLogic(Account account) : _account = account;

  SettingService api() => SettingService(_account);

  Future<LocalSettings> getLocalSettings() async {
    var encoded = (await storage).getString(_localKey);
    if (encoded == null) {
      return LocalSettings(false, ThemeMode.system);
    }

    return LocalSettings.fromJson(json.decode(encoded));
  }

  saveLocal(LocalSettings localSettings) async {
    await (await storage).setString(_localKey, json.encode(localSettings.toJson()));
  }
}
