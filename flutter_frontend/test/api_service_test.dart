import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class TestApiService extends ApiService {
  TestApiService(super.account);
}

void main() {
  test('concurrent services share one token refresh', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({});
    final account = Account();
    await account.setup();

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var refreshCount = 0;
    server.listen((request) async {
      refreshCount++;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      request.response
        ..headers.contentType = ContentType.json
        ..write(
          jsonEncode({
            'accessToken': 'new-access-token',
            'refreshToken': 'new-refresh-token',
            'roles': <String>[],
          }),
        );
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
      const ConnectionResponse(
        accessToken: 'e30.eyJleHAiOjF9.sig',
        refreshToken: 'old-refresh-token',
        roles: [],
      ),
    );

    await Future.wait([
      TestApiService(account).getService(),
      TestApiService(account).getService(),
    ]);

    expect(refreshCount, 1);
    expect(account.getToken()?.accessToken, 'new-access-token');
  });
}
