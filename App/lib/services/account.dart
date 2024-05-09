import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();

  static const url = "urlPath";
  static const token = "sessionToken";
  static const grant = "grant";
  static const redirect = "redirect";
  static const refresh = "refresh";
  static const fitRun = "fitLastRun";
  static const theme = 'theme';
  static const health = 'health';
  static const metrics = 'metrics';
  static const events = 'events';

  Future<String?> get(String name) async {
    return (await storage).getString(name);
  }

  Future<void> set(String name, String value) async {
    await (await storage).setString(name, value);
  }

  Future<void> remove(String name) async {
    await (await storage).remove(name);
  }

  Future<void> clean() async {
    var s = await storage;
    await s.remove(token);
    await s.remove(grant);
    await s.remove(redirect);
    await s.remove(refresh);
    await s.remove(fitRun);
    await s.remove(theme);
    await s.remove(health);
    await s.remove(metrics);
    await s.remove(events);
  }
}
