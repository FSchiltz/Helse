import 'package:shared_preferences/shared_preferences.dart';

/// Token storage abstraction
class Account {
  final storage = SharedPreferences.getInstance();
  final void Function()? callback;

  final _url = "urlPath";
  final _token = "sessionToken";
  final _grant = "grant";
  final _redirect = "redirect";

  Account({this.callback});

  Future<String?> getUrl() async {
    return (await storage).getString(_url);
  }

  Future<void> setUrl(String url) async {
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

  Future<String?> getGrant() async {
    return (await storage).getString(_grant);
  }

  Future<void> setGrant(String grant) async {
    await (await storage).setString(_grant, grant);
  }

    Future<void> removeGrant() async {
    await (await storage).remove(_grant);
  }

  Future<String?> getRedirect() async {
    return (await storage).getString(_redirect);
  }

  Future<void> setRedirect(String redirect) async {
    await (await storage).setString(_redirect, redirect);
  }

    Future<void> removeRedirect() async {
    await (await storage).remove(_redirect);
  }

}
