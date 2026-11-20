import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/account/authentication_bloc.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/services/account.dart';
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
    'checkLogin restores a session with a server-valid refresh token',
    () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({});
      final account = Account();
      await account.setup();

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var refreshCount = 0;
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/api/refresh') {
          refreshCount++;
          request.response.write(
            jsonEncode({
              'accessToken': _jwt({'exp': 4102444800}),
              'refreshToken': _jwt({'session': 'refreshed-session'}),
              'roles': <String>[],
            }),
          );
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
          accessToken: _jwt({'exp': 1}),
          refreshToken: _jwt({'session': 'valid-session'}),
          roles: const [],
        ),
      );
      await Dependencies.init(account: account);

      expect(await Dependencies.logics.authentication.checkLogin(), isTrue);
      expect(refreshCount, 1);
      expect(
        account.getToken()?.refreshToken,
        _jwt({'session': 'refreshed-session'}),
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

String _jwt(Map<String, Object> claims) {
  String encode(Map<String, Object> value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${encode({'alg': 'none'})}.${encode(claims)}.signature';
}
