import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/di/app_logger.dart';
import 'package:helse/helpers/startup_oauth_uri_stub.dart'
    if (dart.library.io) 'package:helse/helpers/startup_oauth_uri_io.dart';
import 'package:helse/logic/account/authentication_bloc.dart';
import 'package:helse/logic/account/settings_migration.dart';
import 'package:helse/services/api/api_login_service.dart';
import 'package:helse/services/local/local_cache_service.dart';
import 'package:helse/services/local/offline_sync_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/helpers/url_dummy.dart'
    if (dart.library.html) 'package:helse/helpers/url.dart';

import '../../services/account.dart';
import '../../di/dependencies.dart';

/// Authentication logic
class AuthenticationLogic {
  final Account account;

  AuthenticationLogic(this.account);

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _connectivityPoll;
  bool _checkingConnectivity = false;

  /// Check if the user is logged in
  Future<bool> checkLogin() async {
    appLogger.d('[Authentication] Checking saved session');
    if (getGrant() != null) {
      appLogger.d(
        '[Authentication] Skipping restoration because an OAuth grant is pending',
      );
      return false;
    }

    await SettingsMigration(account).migrate();
    var token = account.getToken()?.refreshToken;
    if (token == null || token.isEmpty) {
      appLogger.d('[Authentication] No saved refresh token is available');
      return false;
    }

    await _load();
    token = account.getToken()?.refreshToken;
    if (token == null || token.isEmpty) {
      appLogger.d(
        '[Authentication] Restoration cleared the saved refresh token',
      );
      return false;
    }

    setAuth();
    appLogger.i('[Authentication] Saved session restored');
    return true;
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

    if (token != null) {
      final oldUser = account.get(Account.id);
      if (token.id != oldUser) {
        // if the user is different than the last one clear the settings
        appLogger.d('Clear old user settings');
        await account.clear();
        await account.set(Account.id, token.id ?? '');
      } else {
        await account.remove(Account.grant);
      }

      await account.setBool(
        Account.keepConnected,
        connection.keepConnected ?? false,
      );
      await account.setToken(token);

      // todo add a bloc for the settings and load async
      await _load();
      setAuth();
    } else {
      appLogger.e('Auth failed');
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
    required bool keepOpen,
  }) async {
    await account.set(Account.url, url);
    await Dependencies.services.user.addPerson(person);

    // after a succes, we auto login
    await logIn(
      url: url,
      connection: Connection(
        user: person.userName ?? '',
        password: person.password ?? '',
        keepConnected: keepOpen,
      ),
    );

    await clean();
  }

  /// Call the logout service
  Future<void> logOut(bool all) async {
    appLogger.d('Log out');
    await Dependencies.services.user.logout(all);
    await logOutLocal();
  }

  Future<void> clean() async {
    appLogger.d('Cleaned the settings');
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

  Future<void> _submit({
    required String url,
    required String token,
    required bool keepOpen,
  }) async {
    String? issuer;
    String? redirect;

    issuer = getClientId();
    redirect = getRedirect();
    appLogger.d('Auth with: $issuer - $redirect');

    await logIn(
      url: url,
      connection: Connection(
        password: token,
        issuer: issuer,
        user: '',
        redirect: redirect,
        keepConnected: keepOpen,
      ),
    );
  }

  void listen() {
    AppLinks().uriLinkStream.listen(
      (uri) => unawaited(_handleOAuthLink(uri)),
      onError: (Object error, StackTrace stackTrace) {
        appLogger.e(
          '[Authentication] Failed to receive OAuth callback',
          error: error,
          stackTrace: stackTrace,
        );
        setNoAuth();
      },
    );
  }

  Future<bool> _handleOAuthLink(Uri uri) async {
    final redirect = Dependencies.services.login.redirectUrl.toString();
    if (!uri.toString().startsWith(redirect)) return false;

    try {
      final code = await Dependencies.services.login.getCode(
        uri.queryParameters,
      );
      if (code == null) {
        setNoAuth();
        return true;
      }

      if (kIsWeb) {
        UrlHelper.removeParam();
      }

      setNoAuth();
      await _submit(
        url: account.get(Account.url) ?? '',
        token: code,
        keepOpen: account.isEnabled(Account.keepConnected),
      );
    } catch (error, stackTrace) {
      appLogger.e(
        '[Authentication] OAuth callback processing failed',
        error: error,
        stackTrace: stackTrace,
      );
      setNoAuth();
    }

    return true;
  }

  Future<void> _load() async {
    // do here any loading that needs to occur when a user loads but before rendering
    await Dependencies.logics.settings.loadSettings();
    await Dependencies.logics.patientsSettings.loadSettings();
  }

  String normalizeServerUrl(String value) {
    final input = value.trim();
    if (input.isEmpty ||
        input.startsWith('http://') ||
        input.startsWith('https://')) {
      return input;
    }

    return 'https://$input';
  }

  Future<Status?> checkUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.isAbsolute ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw FormatException('Invalid server URL', url);
    }

    Dependencies.blocs.server.setStatus(null);
    var isInit = await Dependencies.services.login.isInit(uri);
    Dependencies.blocs.server.setStatus(isInit);

    setNoAuth();
    var isConnected = false;
    try {
      isConnected = await checkLogin();
    } catch (error, stackTrace) {
      appLogger.e(
        '[Authentication] Failed to restore session: $error\n$stackTrace',
        error: error,
        stackTrace: stackTrace,
      );
    }
    if (isInit != null && isInit.init == true && !isConnected) {
      var keepConnected = account.isEnabled(Account.keepConnected);
      if (isInit.oauths.isNotEmpty) {
        // Start the oauth login procedure
        var autologin = isInit.oauths.firstWhereOrNull((x) => x.autoLogin);
        if (autologin != null) {
          await submitOauth(uri.toString(), autologin, isInit, keepConnected);
        }
      } else if (isInit.externalAuth == true) {
        // directly start the login procedure
        await _submit(
          url: uri.toString(),
          token: 'Header',
          keepOpen: keepConnected,
        );
      }
    }

    return isInit;
  }

  Future<void> submitOauth(
    String url,
    OauthConnection oauth,
    Status isInit,
    bool keepConnected,
  ) async {
    // Save the keep connected for the redirect
    await account.setBool(Account.keepConnected, keepConnected);
    var grant = await Dependencies.services.login.getGrant(url, oauth);
    if (grant != null) {
      await _submit(url: url, token: grant, keepOpen: keepConnected);
    }
  }

  Future<void> init() async {
    resetAuth();
    listen();

    final startupUri = getStartupOAuthUri();
    final handledStartupUri =
        startupUri != null && await _handleOAuthLink(startupUri);
    if (!handledStartupUri) {
      if (await isOffline()) {
        await useOffline();
      } else {
        await _checkInitialConnection();
      }
    }

    _connectivitySubscription ??= Connectivity().onConnectivityChanged.listen(
      (results) => unawaited(_handleConnectivity(results)),
      onError: (Object error, StackTrace stackTrace) {
        appLogger.e(
          '[Network] Connectivity monitoring failed',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
    _connectivityPoll ??= Timer.periodic(const Duration(minutes: 1), (_) async {
      try {
        await _handleConnectivity(await Connectivity().checkConnectivity());
      } catch (error, stackTrace) {
        appLogger.e(
          '[Network] Connectivity check failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.every((result) => result == ConnectivityResult.none)) {
        await _setOffline();
        return;
      }

      final url = getUrl();
      if (url == null || url.isEmpty) {
        Dependencies.blocs.server.setStatus(null);
        setNoAuth();
        return;
      }

      final status = await checkUrl(url);
      if (status == null) {
        await _setOffline();
        return;
      }

      if (Dependencies.blocs.auth.state == AuthenticationStatus.authenticated) {
        await OfflineSyncService(account).syncPendingChanges();
      }
    } catch (error, stackTrace) {
      appLogger.e(
        '[Authentication] Failed to check saved server URL',
        error: error,
        stackTrace: stackTrace,
      );
      await _setOffline();
    }
  }

  Future<void> _handleConnectivity(List<ConnectivityResult> results) async {
    if (account.isEnabled(Account.offline) || _checkingConnectivity) {
      return;
    }

    _checkingConnectivity = true;
    try {
      if (results.every((result) => result == ConnectivityResult.none)) {
        await _setOffline();
        return;
      }

      final url = getUrl();
      if (url == null || url.isEmpty) {
        Dependencies.blocs.server.setStatus(null);
        setNoAuth();
        return;
      }

      final wasOffline = Dependencies.blocs.server.isOffline;
      final status = await ApiLoginService(account).isInit(Uri.parse(url));
      if (status == null) {
        await _setOffline();
        return;
      }

      Dependencies.blocs.server.setStatus(status);
      var canSync =
          Dependencies.blocs.auth.state == AuthenticationStatus.authenticated;
      if (wasOffline ||
          Dependencies.blocs.auth.state == AuthenticationStatus.unknown) {
        final hasSavedSession =
            account.getToken()?.refreshToken.isNotEmpty == true;
        if (hasSavedSession) {
          try {
            canSync = await checkLogin();
          } catch (error, stackTrace) {
            appLogger.e(
              '[Authentication] Failed to restore session after reconnect',
              error: error,
              stackTrace: stackTrace,
            );
            setNoAuth();
            canSync = false;
          }
        } else {
          setNoAuth();
          canSync = false;
        }
      }

      if (canSync) {
        await OfflineSyncService(account).syncPendingChanges();
      }
    } catch (error, stackTrace) {
      appLogger.w(
        '[Network] Server is unreachable; using local data',
        error: error,
        stackTrace: stackTrace,
      );
      await _setOffline();
    } finally {
      _checkingConnectivity = false;
    }
  }

  Future<void> _setOffline() async {
    await _expireOfflineCache();
    Dependencies.blocs.server.setOffline();
    if (account.getToken() != null) {
      setAuth();
    } else {
      setNoAuth();
    }
  }

  Future<void> _expireOfflineCache() async {
    try {
      await LocalCacheService(account).expireServerCache();
    } catch (error, stackTrace) {
      appLogger.e(
        '[OfflineCache] Failed to expire stale server data',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> useOffline() async {
    await _expireOfflineCache();
    Dependencies.blocs.server.setOffline(userInitiated: true);
    if (account.getToken() == null) {
      final token = await Dependencies.services.login.login(
        Connection(user: '', password: ''),
      );
      if (token == null) {
        throw StateError(Translation.current.offlineLoginFailed);
      }
      await account.setToken(token);
    }

    await account.setBool(Account.offline, true);
    setAuth();
  }

  Future<bool> isOffline() async {
    return account.isEnabled(Account.offline);
  }
}
