import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token storage abstraction
class Account {
  final storage = const FlutterSecureStorage();

  final _url = "urlPath";
  final _token = "sessionToken";

  Future<String?> getUrl() {
    return storage.read(key: _url);
  }

  Future<void> setUrl(String url) async {
    await storage.write(key: _url, value: url);
  }

  Future<String?> getToken() {
    return storage.read(key: _token);
  }

  Future<void> setToken(String token) async {
    await storage.write(key: _token, value: token);
  }

  Future<void> removeToken() async {
    await storage.delete(key: _token);
  }

}
