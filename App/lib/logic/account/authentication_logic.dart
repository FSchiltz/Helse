import 'dart:async';
import '../../services/api_service.dart';
import '../../services/account.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication logic
/// TODO Add refresh token support
class AuthenticationLogic {
  final _controller = StreamController<AuthenticationStatus>();
  final Account _account;

  AuthenticationLogic(Account account) : _account = account;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  /// Check if the user is logged in
  Future<void> checkLogin() async {
    var token = await _account.getToken();
    if (token != null && token.isNotEmpty) _controller.add(AuthenticationStatus.authenticated);
  }

  /// Call the login service
  Future<void> logIn({required String url, required String username, required String password}) async {
    await _account.setUrl(url);
    var token = await ApiService(_account).login(username, password);
    if (token != null) {
      var cleaned = token.replaceAll('"', "");
      await _account.setToken(cleaned);
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  Future<void> createAccount(Person person) async {
    await ApiService(_account).createAccount(person);
  }

  Future<bool?> isInit(String url) async {
    return await ApiService(_account).isInit(url);
  }

  /// Call the logout service
  void logOut() {
    _account.removeToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  /// Get the current token
  Future<String?> getToken() {
    return _account.getToken();
  }
}
