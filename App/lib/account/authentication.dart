import 'dart:async';
import '../services/service.dart';
import 'account.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class Authentication {
  final _controller = StreamController<AuthenticationStatus>();
  final _account = Account();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> checkLogin() async {
    var token = await _account.getToken();
    if (token != null && token.isNotEmpty) _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> logIn({required String url, required String username, required String password}) async {
    await _account.setUrl(url);
    var token = await Service(url).login(username, password);
    if (token != null) {
      var cleaned = token.replaceAll('"', "");
      await _account.setToken(cleaned);
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void logOut() {
    _account.removeToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  Future<String?> getToken() {
    return _account.getToken();
  }
}
