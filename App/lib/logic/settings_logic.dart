import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/account.dart';
import '../services/setting_service.dart';

class OrderedItem {
  bool visible = true;
  int order = 0;
  late String name;
}

class LocalSettings {
  static const _syncHealth = "syncHealth";
  bool syncHealth;

  static const _theme = "theme";
  ThemeMode theme;

  static const _metrics = "metrics";
  List<OrderedItem>? metrics;

  static const _events = "events";
  List<OrderedItem>? events;

  LocalSettings(this.syncHealth, this.theme, {this.metrics, this.events});

  // stupid boilerplate code because dart can't decode json
  LocalSettings.fromJson(dynamic json)
      : syncHealth = json[_syncHealth] as bool,
      metrics = json[_metrics] as List<OrderedItem>?,
      events = json[_events]as List<OrderedItem>?,
        theme =  ThemeMode.values.firstWhere((e) => e.name == json[_theme]);

  Map<String, dynamic> toJson() => {
        _syncHealth: syncHealth,
        _theme: theme.name,
        _metrics: metrics,
        _events: events;

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

  Future<void> saveLocal(LocalSettings localSettings) async {
    await (await storage).setString(_localKey, json.encode(localSettings.toJson()));
  }
}
