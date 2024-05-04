import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();

  static const url = "urlPath";
  static const token = "sessionToken";
  static const grant = "grant";
  static const redirect = "redirect";
  static const refresh = "refresh";

  Future<String?> get(String name) async {
    return (await storage).getString(name);
  }

  Future<void> set(String name, String value) async {
    await (await storage).setString(name, value);
  }

  Future<void> remove(String name) async {
    await (await storage).remove(name);
  }
}
