import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/account/authentication_bloc.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  final logic = AuthenticationLogic(Account());

  group('normalizeServerUrl', () {
    test('trims whitespace and adds https to a host', () {
      expect(logic.normalizeServerUrl(' example.com '), 'https://example.com');
    });

    test('preserves explicit http and https schemes', () {
      expect(
        logic.normalizeServerUrl(' http://example.com '),
        'http://example.com',
      );
      expect(
        logic.normalizeServerUrl('https://example.com'),
        'https://example.com',
      );
    });

    test('keeps an empty URL empty', () {
      expect(logic.normalizeServerUrl('  '), isEmpty);
    });
  });

  test(
    'checkUrl rejects non-absolute, hostless, and unsupported URLs',
    () async {
      for (final url in [
        '',
        '/relative/path',
        'https://',
        'ftp://example.com',
      ]) {
        await expectLater(logic.checkUrl(url), throwsA(isA<FormatException>()));
      }
    },
  );

  test(
    'checkLogin refreshes a session without an access token',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({});
      final account = Account();
      await account.setup();

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final refreshedAccessToken = _jwt({'exp': 4102444800});
      var refreshCount = 0;
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/api/refresh') {
          refreshCount++;
          request.response.write(
            jsonEncode({
              'accessToken': refreshedAccessToken,
              'refreshToken': _jwt({'session': 'refreshed-session'}),
              'roles': <String>[],
            }),
          );
        } else if (request.headers.value(HttpHeaders.authorizationHeader) !=
            'Bearer $refreshedAccessToken') {
          request.response.statusCode = HttpStatus.unauthorized;
        } else {
          request.response.write('{}');
        }
        await request.response.close();
      });
      addTearDown(() => server.close(force: true));

      await account.set(
        Account.url,
        Uri(
          scheme: 'http',
          host: server.address.address,
          port: server.port,
        ).toString(),
      );
      await account.setToken(
        ConnectionResponse(
          accessToken: '',
          refreshToken: _jwt({'session': 'valid-session'}),
          roles: const [],
        ),
      );
      await Dependencies.init(account: account);

      expect(await Dependencies.logics.authentication.checkLogin(), isTrue);
      expect(refreshCount, 1);
      expect(account.getToken()?.accessToken, refreshedAccessToken);
      expect(
        account.getToken()?.refreshToken,
        _jwt({'session': 'refreshed-session'}),
      );
      expect(Dependencies.blocs.auth.state, AuthenticationStatus.authenticated);
    },
  );

  test(
    'checkUrl falls back to OAuth when a saved refresh token is rejected',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({});
      final account = Account();
      await account.setup();

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.statusCode = HttpStatus.unauthorized;
        await request.response.close();
      });
      addTearDown(() => server.close(force: true));

      final url = Uri(
        scheme: 'http',
        host: server.address.address,
        port: server.port,
      ).toString();
      await account.set(Account.url, url);
      await account.setToken(
        ConnectionResponse(
          accessToken: _jwt({'exp': 1}),
          refreshToken: _jwt({'session': 'expired-session'}),
          roles: const [],
        ),
      );
      await Dependencies.init(account: account);

      var oauthAttempted = false;
      Dependencies.services.login = _LoginService(
        Status(
          init: true,
          externalAuth: false,
          oauths: const [
            OauthConnection(
              name: 'Provider',
              url: 'https://oauth.example/authorize',
              clientId: 'client-id',
              autoLogin: true,
            ),
          ],
        ),
        onGetGrant: () async {
          oauthAttempted = true;
          return null;
        },
      );

      await Dependencies.logics.authentication.checkUrl(url);

      expect(oauthAttempted, isTrue);
      expect(account.getToken(), isNull);
    },
  );

  test(
    'checkUrl restores login with a valid refresh token and expired access token',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({});
      final account = Account();
      await account.setup();

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var refreshCount = 0;
      var rejectedAccessRequests = 0;
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/api/status') {
          request.response.write(
            jsonEncode({
              'init': true,
              'externalAuth': false,
              'oauths': <Object>[],
            }),
          );
        } else if (request.uri.path == '/api/refresh') {
          refreshCount++;
          request.response.write(
            jsonEncode({
              'accessToken': _jwt({'exp': 4102444800}),
              'refreshToken': _jwt({'session': 'refreshed-session'}),
              'roles': <String>[],
            }),
          );
        } else if (request.headers.value(HttpHeaders.authorizationHeader) ==
            'Bearer ${_jwt({'exp': 1})}') {
          rejectedAccessRequests++;
          request.response.statusCode = HttpStatus.unauthorized;
        } else {
          request.response.write('{}');
        }
        await request.response.close();
      });
      addTearDown(() => server.close(force: true));

      final url = Uri(
        scheme: 'http',
        host: server.address.address,
        port: server.port,
      ).toString();
      await account.set(Account.url, url);
      await account.setToken(
        ConnectionResponse(
          accessToken: _jwt({'exp': 1}),
          refreshToken: _jwt({'session': 'valid-session'}),
          roles: const [],
        ),
      );
      await Dependencies.init(account: account);

      await Dependencies.logics.authentication.checkUrl(url);

      expect(refreshCount, 1);
      expect(rejectedAccessRequests, 0);
      expect(account.getToken()?.accessToken, _jwt({'exp': 4102444800}));
      expect(
        account.getToken()?.refreshToken,
        _jwt({'session': 'refreshed-session'}),
      );
      expect(Dependencies.blocs.auth.state, AuthenticationStatus.authenticated);
    },
  );

  test(
    'checkLogin retries a request with a refreshed token after access rejection',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({});
      final account = Account();
      await account.setup();

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final invalidAccessToken = _jwt({'exp': 4102444800});
      final refreshedAccessToken = _jwt({
        'exp': 4102444800,
        'session': 'refreshed-session',
      });
      var refreshCount = 0;
      var settingsRequests = 0;
      var rejectedAccessRequests = 0;
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/api/refresh') {
          refreshCount++;
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Bearer ${_jwt({'session': 'valid-session'})}',
          );
          request.response.write(
            jsonEncode({
              'accessToken': refreshedAccessToken,
              'refreshToken': _jwt({'session': 'rotated-session'}),
              'roles': <String>[],
            }),
          );
        } else {
          settingsRequests++;
          final authorization = request.headers.value(
            HttpHeaders.authorizationHeader,
          );
          if (authorization == 'Bearer $invalidAccessToken') {
            rejectedAccessRequests++;
            request.response.statusCode = HttpStatus.unauthorized;
          } else if (authorization == 'Bearer $refreshedAccessToken') {
            request.response.write('{}');
          } else {
            request.response.statusCode = HttpStatus.unauthorized;
          }
        }
        await request.response.close();
      });
      addTearDown(() => server.close(force: true));

      await account.set(
        Account.url,
        Uri(
          scheme: 'http',
          host: server.address.address,
          port: server.port,
        ).toString(),
      );
      await account.setToken(
        ConnectionResponse(
          accessToken: invalidAccessToken,
          refreshToken: _jwt({'session': 'valid-session'}),
          roles: const [],
        ),
      );
      await Dependencies.init(account: account);

      expect(await Dependencies.logics.authentication.checkLogin(), isTrue);
      expect(refreshCount, 1);
      expect(settingsRequests, 3);
      expect(rejectedAccessRequests, 1);
      expect(
        account.getToken()?.refreshToken,
        _jwt({'session': 'rotated-session'}),
      );
      expect(Dependencies.blocs.auth.state, AuthenticationStatus.authenticated);
    },
  );

  test('logIn saves the selected keep-connected setting', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({});
    final account = Account();
    await account.setup();

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode({
          'id': 'user-id',
          'accessToken': _jwt({'exp': 4102444800}),
          'refreshToken': _jwt({'session': 'session-id'}),
          'roles': <String>[],
        }),
      );
      await request.response.close();
    });
    addTearDown(() => server.close(force: true));

    final url = Uri(
      scheme: 'http',
      host: server.address.address,
      port: server.port,
    ).toString();
    await Dependencies.init(account: account);

    await Dependencies.logics.authentication.logIn(
      url: url,
      connection: const Connection(
        user: 'user',
        password: 'password',
        keepConnected: true,
      ),
    );

    expect(account.isEnabled(Account.keepConnected), isTrue);
  });
}

class _LoginService implements LoginService {
  final Status status;
  final Future<String?> Function() onGetGrant;

  _LoginService(this.status, {required this.onGetGrant});

  @override
  Future<Status?> isInit(Uri url) async => status;

  @override
  Future<String?> getGrant(String url, OauthConnection oauth) => onGetGrant();

  @override
  Future<ConnectionResponse?> login(Connection connection) async => null;

  @override
  Uri get redirectUrl => Uri.parse('com.helse://login-callback');

  @override
  Future<String?> getCode(Map<String, String> uri) async => null;
}

String _jwt(Map<String, Object> claims) {
  String encode(Map<String, Object> value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${encode({'alg': 'none'})}.${encode(claims)}.signature';
}
