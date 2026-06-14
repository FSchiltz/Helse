import 'dart:convert';
import 'package:helse/services/account.dart';
import 'package:helse/services/setting_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSettingsLogic {
  static final storage = SharedPreferences.getInstance();
  final Account account;
  final SettingService service;

  BaseSettingsLogic(this.account, this.service);

  Future<void> save(String key, Map<String, dynamic> data) async {
    (await storage).setString(key, json.encode(data));
  }

  Future<String?> getString(String key) async {
    return (await storage).getString(key);
  }

  Future<bool?> getBool(String key) async {
    return (await storage).getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    (await storage).setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    (await storage).setString(key, value);
  }

  Future<void> remove(String key) async {
    (await storage).remove(key);
  }
}
