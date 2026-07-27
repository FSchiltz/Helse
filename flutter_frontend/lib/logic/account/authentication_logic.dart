import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/logic/account/settings_migration.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:helse/helpers/url_dummy.dart'
    if (dart.library.html) 'package:helse/helpers/url.dart';

import '../../services/account.dart';
import '../../di/dependencies.dart';

enum AuthenticationStatus { unknown,unset,authenticated, unauthenticated }

/// Authentication logic
class AuthenticationLogic {
  final Account account;

  AuthenticationLogic(this.account);

  /// Check if the user is logged in
  Future<bool> checkLogin() async {
    if (getGrant() != null) {
      return false;
    }

    await SettingsMigration(account).migrate();
    var token = account.getToken()?.refreshToken;
    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      await _load();
      setAuth();

      return true;
    }

    return false;
  }

  void setAuth() {
    Dependencies.blocs.auth.add(AuthenticationStatus.authenticated);
  }

  void setNoAuth() {
    Dependencies.blocs.auth.add(AuthenticationStatus.unauthenticated);
  }

  void resetAuth() {
    Dependencies.blocs.auth.add(AuthenticationStatus.unknown);
  }

  /// Call the login service
  Future<void> logIn({
    required String url,
    required Connection connection,
  }) async {
    await account.set(Account.url, url);
    var token = await Dependencies.services.login.login(connection);

    if (token != null && token.refreshToken != null) {
      final oldUser = account.get(Account.id);
      if (token.id != oldUser) {
        // if the user is different than the last one clear the settings
        log('Clear old user settings');
        await account.clear();
        await account.set(Account.id, token.id ?? '');
      } else {
        await account.remove(Account.grant);
      }

      await account.setToken(token);

      // todo add a bloc for the settings and load async
      await _load();
      setAuth();
    } else {
      log('Auth failed');
      setNoAuth();
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
    await Dependencies.services.user.addPerson(person);

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
    log('Log out');
    await Dependencies.services.user.logout(all);
    await logOutLocal();
  }

  Future<void> clean() async {
    log('Cleaned the settings');
    await account.clean();
    Dependencies.logics.settings.init = false;
  }

  Future<void> logOutLocal() async {
    await account.clear();
    Dependencies.logics.settings.init = false;
    setNoAuth();
  }

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
    var redirect = Dependencies.services.login.redirectUrl.toString();
    links.uriLinkStream.listen((uri) async {
      if (uri.toString().startsWith(redirect)) {
        var code = await Dependencies.services.login.getCode(
          uri.queryParameters,
        );
        if (code != null) {
          if (kIsWeb) {
            UrlHelper.removeParam();
            log("Auth code found");
          }

          var url = account.get(Account.url);

          setNoAuth();
          await startOauthLogin(token: code, url: url ?? '');
        }
      }
    });
  }

  Future<void> _load() async {
    // do here any loading that needs to occur when a user loads but before rendering
    await Dependencies.logics.settings.loadSettings();
    await Dependencies.logics.patientsSettings.loadSettings();
  }

  // Check that the given url is valid and already logged into
  Future<Status?> checkUrl(Uri uri) async {
    var isInit = await Dependencies.services.login.isInit(uri);
    Dependencies.blocs.server.setStatus(isInit);

    setNoAuth();
    var isConnected = await checkLogin();
    if (isInit != null && isInit.init == true && !isConnected) {
      if (isInit.oauths.isNotEmpty) {
        // Start the oauth login procedure
        var autologin = isInit.oauths.firstWhereOrNull((x) => x.autoLogin);
        if (autologin != null) {
          await submitOauth(uri.toString(), autologin, isInit);
        }
      } else if (isInit.externalAuth == true) {
        // directly start the login procedure
        await submit(uri.toString(), 'Header');
      }
    }

    return isInit;
  }

  Future<void> submit(String url, String oAuth) async {
    log("Oauth in progress");
    await Dependencies.logics.authentication.startOauthLogin(
      token: oAuth,
      url: url,
    );
  }

  Future<void> submitOauth(
    String url,
    OauthConnection oauth,
    Status isInit,
  ) async {
    var grant = await Dependencies.services.login.getGrant(url, oauth);
    if (grant != null) {
      await submit(url, grant);
    }
  }

  Future<void> init() async {
    resetAuth();
    final offline = await isOffline();
    if (offline) {
      await useOffline();
      await logIn(
        url: '',
        connection: Connection(user: '', password: ''),
      );
    } else {
      final url = account.get(Account.url);
      if (url != null && url.isNotEmpty) {
        var uri = Uri.tryParse(url);
        if (uri != null) {
          await checkUrl(uri);
        }
      }
    }
  }

  Future<void> useOffline() async {
    Dependencies.blocs.server.setOffline();
    await account.setBool(Account.offline, true);
  }

  Future<bool> isOffline() async {
    return account.isEnabled(Account.offline);
  }
}
