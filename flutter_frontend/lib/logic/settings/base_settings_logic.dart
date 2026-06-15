import 'dart:convert';
import 'package:helse/services/account.dart';
import 'package:helse/services/setting_service.dart';

class BaseSettingsLogic {
  final Account account;
  final SettingService service;

  BaseSettingsLogic(this.account, this.service);

  Future<void> save(String key, Map<String, dynamic> data) async {
    await Account.storage.setString(key, json.encode(data));
  }

  String? getString(String key) {
    return Account.storage.getString(key);
  }

  bool? getBool(String key) {
    return Account.storage.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    await Account.storage.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    await Account.storage.setString(key, value);
  }

  Future<void> remove(String key) async {
    await Account.storage.remove(key);
  }
}
