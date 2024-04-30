import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();
  final void Function()? callback;

  static const url = "urlPath";
  static const token = "sessionToken";
  static const grant = "grant";
  static const redirect = "redirect";
  static const refresh = "refresh";

  Account({this.callback});

  Future<void> clear() async {
    await (await storage).remove(token);
    await (await storage).remove(grant);
    await (await storage).remove(grant);

    callback?.call();
  }

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
