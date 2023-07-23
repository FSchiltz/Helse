import 'dart:async';
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
    // TODO get token

    await _account.setUrl(url);
    await _account.setToken("test");
    await Future.delayed(const Duration(milliseconds: 300), () => _controller.add(AuthenticationStatus.authenticated));
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
