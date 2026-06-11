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
  static const fitRun = "fitLastRun";
  static const colors = "colors";
  static const fitHistory = "fitHistory";
  static const fitBackground = "fitBackground";
  static const fitStatus = 'fitStatus';
  static const health = 'health';
  static const settings = 'settings';
  static const patients = 'patients';

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
    await s.remove(grant);
    await s.remove(redirect);
    await s.remove(clientid);
    await s.remove(refresh);
    await s.remove(fitRun);
    await s.remove(fitHistory);
    await s.remove(fitStatus);
    await s.remove(patients);
    await s.remove(health);
    await s.remove(settings);
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
