import 'dart:convert';
import 'package:helse/services/account.dart';
import 'package:helse/services/setting_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSettingsLogic {
  static Future<SharedPreferencesWithCache> get _instance async =>
      _storage ??= await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(),
      );

  static SharedPreferencesWithCache? _storage;
  static SharedPreferencesWithCache get storage {
    if (_storage == null) {
      throw Error();
    }

    return _storage!;
  }

  // call this method from iniState() function of mainApp().
  static Future<void> setup() async {
    _storage = await _instance;
  }

  final Account account;
  final SettingService service;

  BaseSettingsLogic(this.account, this.service);

  void save(String key, Map<String, dynamic> data) {
    (storage).setString(key, json.encode(data));
  }

  String? getString(String key) {
    return storage.getString(key);
  }

  bool? getBool(String key) {
    return storage.getBool(key);
  }

  void setBool(String key, bool value) {
    storage.setBool(key, value);
  }

  void setString(String key, String value) {
    (storage).setString(key, value);
  }

  void remove(String key) {
    storage.remove(key);
  }
}
