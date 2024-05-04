import 'dart:async';
import 'package:helse/services/user_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../main.dart';
import '../../services/account.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication logic
class AuthenticationLogic {
  final _controller = StreamController<AuthenticationStatus>();
  final Account _account;

  AuthenticationLogic(Account account) : _account = account;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  UserService _api() => UserService(_account);

  /// Check if the user is logged in
  Future<void> checkLogin() async {
    var token = await _account.get(Account.token);
    if (token != null && token.isNotEmpty) {
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void setLogin() {
    _controller.add(AuthenticationStatus.authenticated);
  }

  /// Call the login service
  Future<void> logIn(
      {required String url,
      required String username,
      required String password,
      String? redirect}) async {
    await _account.set(Account.url, url);
    var token = await DI.user?.login(username, password, redirect);

    if (token?.refreshToken != null) {
      await _account.set(Account.refresh, token?.refreshToken ?? '');
      await _account.set(Account.token, token?.accessToken ?? '');
      await _account.remove(Account.grant);

      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<Person> getUser() async {
    var token = await _account.get(Account.refresh);
    if (token == null) throw Exception("Not connected");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var data = decodedToken["roles"];
    if (data == null) {
      return const Person(type: UserType.swaggerGeneratedUnknown);
    }

    var name = decodedToken["name"];
    if (name?.isEmpty ?? true) name = null;

    var surname = decodedToken["surname"];

    if (surname?.isEmpty ?? true) surname = null;

    // the enum start at 0 so we add 1
    UserType role = UserType.values[int.parse(data) + 1];
    return Person(type: role, name: name, surname: surname);
  }

  /// Init the account for a first connection
  Future<void> initAccount(
      {required String url, required PersonCreation person}) async {
    await _account.set(Account.url, url);
    await _api().addPerson(person);
  }

  /// Call the logout service
  Future<void> logOut() async {
    await _account.remove(Account.token);
    await _account.remove(Account.redirect);
    await _account.remove(Account.grant);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  /// Get the current token
  Future<bool> isAuth() async {
    var token = await _account.get(Account.refresh);
    return token != null;
  }

  Future<String?> getGrant() {
    return _account.get(Account.grant);
  }

  Future<String?> getRedirect() {
    return _account.get(Account.redirect);
  }

  Future<String?> getUrl() {
    return _account.get(Account.url);
  }
}
