import 'dart:convert';

import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
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

  static const url = "urlPath";
  static const grant = "grant";
  static const redirect = "redirect";
  static const clientid = "clientid";
  static const refresh = "refresh";
  static const id = "id";

  String? get(String name) {
    var store = storage;
    var url = store.getString(name);
    return url;
  }

  Future<void> set(String name, String value) async {
    await (storage).setString(name, value);
  }

  Future<void> remove(String name) async {
    await (storage).remove(name);
  }

  Future<void> clean() async {
    var s = storage;
    await s.remove(grant);
    await s.remove(redirect);
    await s.remove(clientid);
    await s.remove(refresh);
  }

  Future<void> clear() async {
    var s = storage;
    var oldUrl = s.getString(url);
    await s.clear();
    if (oldUrl != null) s.setString(url, oldUrl);
  }

  ConnectionResponse? getToken() {
    var token = get(Account.refresh);
    if (token == null) return null;
    return ConnectionResponse.fromJson(
      json.decode(token) as Map<String, Object?>,
    );
  }

  Future<void> setToken(ConnectionResponse token) async {
    await set(refresh, json.encode(token.toJson()));
  }
}
