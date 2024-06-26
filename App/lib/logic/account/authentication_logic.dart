import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/user_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../services/account.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';
import '../d_i.dart';

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
    var token = await _account.get(Account.refresh);
    if (token != null && token.isNotEmpty) {
      // TODO check the validity
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void set(AuthenticationStatus status) {
    _controller.add(status);
  }

  /// Call the login service
  Future<void> logIn({required String url, required String username, required String password, String? redirect}) async {
    await _account.set(Account.url, url);
    var token = await LoginService(_account).login(username, password, redirect);

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
    var data = decodedToken["roles"] as String?;
    if (data == null) {
      return const Person(type: UserType.swaggerGeneratedUnknown);
    }

    var name = decodedToken["name"] as String?;
    if (name?.isEmpty ?? true) name = null;

    var surname = decodedToken["surname"] as String?;

    if (surname?.isEmpty ?? true) surname = null;

    // the enum start at 0 so we add 1
    UserType role = UserType.values.firstWhere((x) => x.value == int.parse(data));
    return Person(type: role, name: name, surname: surname);
  }

  /// Init the account for a first connection
  Future<void> initAccount({required String url, required PersonCreation person}) async {
    await _account.set(Account.url, url);
    await _api().addPerson(person);
  }

  /// Call the logout service
  Future<void> logOut() async {
    await _account.clean();
    DI.fit.cancel();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> clean() async {
    await _account.remove(Account.redirect);
    await _account.remove(Account.grant);
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

  Future<String?> getUrl() async {
    var url = await _account.get(Account.url);

    // if not in storage, we can try to get it from the current url on the web
    if (url == null && kIsWeb) {
      int? port = Uri.base.port;
      if (port == 80 && Uri.base.scheme == 'http') {
        // if the url is http, don't show the default port
        port = null;
      }

      if (port == 443 && Uri.base.scheme == 'https') {
        // if the url is https, don't show the default port
        port = null;
      }

      url = "${Uri.base.scheme}://${Uri.base.host}${port != null ? ":$port" : ""}";
    }

    return url;
  }
}
