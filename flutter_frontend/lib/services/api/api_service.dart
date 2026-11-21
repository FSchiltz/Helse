import 'dart:async';
import 'dart:developer';
import 'package:chopper/chopper.dart';
import 'package:helse/services/api/refresh_authenticator.dart';
import 'package:helse/services/api/service_error.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../di/dependencies.dart';
import '../account.dart';

abstract class ApiService {
  static Future<String?>? _refreshInProgress;

  final Account account;

  ApiService(this.account);

  Future<T?> call<T>(Future<Response<T>> Function() call) async {
    final stopwatch = Stopwatch()..start();
    final response = await call();
    if (stopwatch.elapsedMilliseconds > 300) {
      log(
        'Service call executed in ${stopwatch.elapsed}',
        level: stopwatch.elapsedMilliseconds > 1000 ? 2000 : 0,
        name: 'ServiceCall',
      );
    }

    T? result;

    if (!response.isSuccessful) {
      switch (response.statusCode) {
        case 401:
          // no auth, we remove the token and return null;
          await Dependencies.logics.authentication.logOutLocal();
          result = null;
          break;
        default:
          throw ServiceError(
            response.statusCode,
            message: "Error during the call",
            description: response.error?.toString(),
          );
      }
    } else {
      result = response.body;
    }
    return result;
  }

  Future<String?> refreshToken(
    ConnectionResponse? settings,
    Uri url,
    bool keepConnected,
  ) async {
    final pendingRefresh = _refreshInProgress;
    if (pendingRefresh != null) {
      return pendingRefresh;
    }

    final refresh = _requestTokenRefresh(settings, url, keepConnected);
    _refreshInProgress = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshInProgress, refresh)) {
        _refreshInProgress = null;
      }
    }
  }

  Future<String?> _requestTokenRefresh(
    ConnectionResponse? settings,
    Uri url,
    bool keepConnected,
  ) async {
    var client = Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({
          'Authorization': 'Bearer ${settings?.refreshToken}',
        }),
      ],
    );
    var response = await client.apiRefreshGet(keepConnected: keepConnected);
    var connection = response.body;
    if (connection != null) {
      var token = ConnectionResponse(
        id: connection.id,
        accessToken: connection.accessToken,
        roles: connection.roles,
        refreshToken: connection.refreshToken,
      );
      await account.setToken(token);
      return token.accessToken;
    }
    return null;
  }

  Helseapi getApi(Uri url, String? token) {
    if (token == null) {
      return Helseapi.create(baseUrl: url);
    }

    return Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({'Authorization': 'Bearer $token'}),
      ],
      authenticator: RefreshAuthenticator(this),
    );
  }

  Future<Helseapi> getService({Uri? override, bool sendRefresh = false}) async {
    var url = override ?? Uri.parse(account.get(Account.url) ?? '');
    final settings = account.getToken();

    if (sendRefresh) {
      final token = settings?.refreshToken;
      return Helseapi.create(
        baseUrl: url,
        interceptors: token == null
            ? []
            : [
                HeadersInterceptor({'Authorization': 'Bearer $token'}),
              ],
      );
    }

    String? token = settings?.accessToken;
    if (token == null || token.isEmpty || _isExpired(token)) {
      token = await refreshToken(
        settings,
        url,
        account.isEnabled(Account.keepConnected),
      );
    }

    return getApi(url, token);
  }

  bool _isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (error) {
      return true;
    }
  }
}
