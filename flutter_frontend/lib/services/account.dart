import 'dart:convert';

import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();

  static const url = "urlPath";
  static const grant = "grant";
  static const redirect = "redirect";
  static const clientid = "clientid";
  static const refresh = "refresh";

  Future<String?> get(String name) async {
    var store = await storage;
    var url = store.getString(name);
    return url;
  }

  Future<void> set(String name, String value) async {
    await (await storage).setString(name, value);
  }

  Future<void> remove(String name) async {
    await (await storage).remove(name);
  }

  Future<void> clean() async {
    var s = await storage;
    var oldUrl = s.getString(url);
    await s.clear();
    if (oldUrl != null) s.setString(url, oldUrl);
  }

  Future<ConnectionResponse?> getToken() async {
    var token = await get(Account.refresh);
    if (token == null) return null;
    return ConnectionResponse.fromJson(
      json.decode(token) as Map<String, Object?>,
    );
  }

  Future<void> setToken(ConnectionResponse token) async {
    await set(refresh, json.encode(token.toJson()));
  }
}
