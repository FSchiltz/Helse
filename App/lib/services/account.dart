import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();
  final void Function()? callback;

  final _url = "urlPath";
  final _token = "sessionToken";

  Account({this.callback});

  Future<String?> getUrl() async {
    return (await storage).getString(_url);
  }

  Future<void> setUrl(String url) async {
    print("setting url :$url");
    await (await storage).setString(_url, url);
  }

  Future<String?> getToken() async {
    return (await storage).getString(_token);
  }

  Future<void> setToken(String token) async {
    await (await storage).setString(_token, token);
  }

  Future<void> removeToken() async {
    await (await storage).remove(_token);
    
    callback?.call();
  }
}
