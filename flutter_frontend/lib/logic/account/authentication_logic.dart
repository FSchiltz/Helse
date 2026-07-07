import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/logic/account/settings_migration.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/services/user_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:helse/helpers/url_dummy.dart'
    if (dart.library.html) 'package:helse/helpers/url.dart';

import '../../services/account.dart';
import '../../di/dependencies.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

/// Authentication logic
class AuthenticationLogic {
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  final Account account;

  AuthenticationLogic(this.account);

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  UserService _api() => UserService(account);

  /// Check if the user is logged in
  Future<bool> checkLogin() async {
    await SettingsMigration(account).migrate();
    var token = account.getToken()?.refreshToken;
    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      await _load();
      _controller.add(AuthenticationStatus.authenticated);

      return true;
    }

    return false;
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

    if (token != null && token.refreshToken != null) {
      await account.setToken(token);
      await account.remove(Account.grant);

      // todo add a bloc for the settings and load async
      await _load();
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      log('Auth failed');
      _controller.add(AuthenticationStatus.unauthenticated);
      throw StateError('Auth failed');
    }
  }

  Person getUser() {
    var response = account.getToken();

    return Person(types: response?.roles ?? [], id: 0);
  }

  /// Init the account for a first connection
  Future<void> initAccount({
    required String url,
    required PersonCreation person,
  }) async {
    await account.set(Account.url, url);
    await _api().addPerson(person);

    // after a succes, we auto login
    await logIn(
      url: url,
      connection: Connection(
        user: person.userName ?? '',
        password: person.password ?? '',
      ),
    );

    await clean();
  }

  /// Call the logout service
  Future<void> logOut(bool all) async {
    await Dependencies.services.user.logout(all);
    await logOutLocal();
  }

  Future<void> logOutLocal() async {
    await account.clean();
    Dependencies.logics.settings.init = false;
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> clean() async {
    await account.remove(Account.redirect);
    await account.remove(Account.grant);
    await account.remove(Account.clientid);
  }

  void dispose() => _controller.close();

  String? getGrant() {
    return account.get(Account.grant);
  }

  String? getRedirect() {
    return account.get(Account.redirect);
  }

  String? getClientId() {
    return account.get(Account.clientid);
  }

  String? getUrl() {
    var url = account.get(Account.url);

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

  Future<void> startOauthLogin({
    required String url,
    required String token,
  }) async {
    String? issuer;
    String? redirect;

    issuer = getClientId();
    redirect = getRedirect();
    log('Auth with: $issuer - $redirect');

    await logIn(
      url: url,
      connection: Connection(
        password: token,
        issuer: issuer,
        user: '',
        redirect: redirect,
      ),
    );
  }

  void listen() async {
    var links = AppLinks();
    var redirect = Dependencies.services.authService.redirectUrl.toString();
    links.uriLinkStream.listen((uri) async {
      if (uri.toString().startsWith(redirect)) {
        var code = await Dependencies.services.authService.getCode(
          uri.queryParameters,
        );
        if (code != null) {
          if (kIsWeb) {
            UrlHelper.removeParam();
            log("Auth code found");
          }

          var url = account.get(Account.url);

          set(AuthenticationStatus.unauthenticated);
          await startOauthLogin(token: code, url: url ?? '');
        }
      }
    });
  }

  Future<bool> checkIfNeedsLogging() async {
    var grant = getGrant();
    var isLogged = await checkLogin();
    return grant == null && !isLogged;
  }

  Future<void> _load() async {
    // do here any loading that needs to occur when a user loads but before rendering
    await Dependencies.logics.settings.loadSettings();
    await Dependencies.logics.patientsSettings.loadSettings();
  }
}
