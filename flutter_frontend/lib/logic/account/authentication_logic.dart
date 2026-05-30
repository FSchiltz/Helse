import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/services/user_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../services/account.dart';
import '../../di/dependencies.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication logic
class AuthenticationLogic {
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  final Account account;

  AuthenticationLogic(this.account);

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  UserService _api() => UserService(account);

  /// Check if the user is logged in
  Future<void> checkLogin() async {
    var token = await account.get(Account.refresh);
    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void set(AuthenticationStatus status) {
    _controller.add(status);
  }

  /// Call the login service
  Future<void> logIn({
    required String url,
    required Connection connection,
  }) async {
    await account.set(Account.url, url);
    var token = await LoginService(account).login(connection);

    if (token?.refreshToken != null) {
      await account.set(Account.refresh, token?.refreshToken ?? '');
      await account.set(Account.token, token?.accessToken ?? '');
      await account.remove(Account.grant);

      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<Person> getUser() async {
    var token = await account.get(Account.refresh);
    if (token == null) throw StateError("Not connected");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var data = decodedToken["roles"] as String?;
    if (data == null) {
      return const Person(types: [UserType.swaggerGeneratedUnknown], id: 0);
    }

    var name = decodedToken["name"] as String?;
    if (name?.isEmpty ?? true) name = null;

    var surname = decodedToken["surname"] as String?;

    if (surname?.isEmpty ?? true) surname = null;

    var splitted = data.split(';');
    List<UserType> roles = splitted
        .map(
          (e) =>
              UserType.values.firstWhereOrNull((x) => x.value == e) ??
              UserType.swaggerGeneratedUnknown,
        )
        .toList();
    return Person(types: roles, name: name, surname: surname, id: 0);
  }

  /// Init the account for a first connection
  Future<void> initAccount({
    required String url,
    required PersonCreation person,
  }) async {
    await account.set(Account.url, url);
    await _api().addPerson(person);
  }

  /// Call the logout service
  Future<void> logOut() async {
    await account.clean();
    Dependencies.logics.settings.init = false;
    Dependencies.blocs.fit.cancel();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> clean() async {
    await account.remove(Account.redirect);
    await account.remove(Account.grant);
    await account.remove(Account.clientid);
  }

  void dispose() => _controller.close();

  /// Get the current token
  Future<bool> isAuth() async {
    var token = await account.get(Account.refresh);
    return token != null;
  }

  Future<String?> getGrant() {
    return account.get(Account.grant);
  }

  Future<String?> getRedirect() {
    return account.get(Account.redirect);
  }

  Future<String?> getClientId() {
    return account.get(Account.clientid);
  }

  Future<String?> getUrl() async {
    var url = await account.get(Account.url);

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

      url =
          "${Uri.base.scheme}://${Uri.base.host}${port != null ? ":$port" : ""}";
    }

    return url;
  }
}
