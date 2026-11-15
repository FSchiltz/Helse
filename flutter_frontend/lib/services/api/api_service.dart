import 'dart:async';
import 'dart:developer';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../di/dependencies.dart';
import '../account.dart';

class ServiceError {
  final String message;
  final String? description;
  final int code;

  ServiceError(this.code, {required this.message, this.description});

  bool _isClientError() {
    return code < 500 && code >= 400;
  }

  @override
  String toString() {
    // TODO better manage the return values
    if (_isClientError()) {
      return "Invalid object state";
    }

    return "Server error";
  }
}

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
          Dependencies.logics.authentication.logOutLocal();
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

  Future<String?> _refreshToken(
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
    );
  }

  Future<Helseapi> getService({Uri? override, bool sendRefresh = false}) async {
    var url = override ?? Uri.parse(account.get(Account.url) ?? '');
    var keepConnected = account.isEnabled(Account.keepConnected);

    // first we try to get a new refresh token if needed
    String? token;
    var settings = account.getToken();

    if (sendRefresh) {
      token = settings?.refreshToken;
    } else {
      token = settings?.accessToken;
      if (token == null || token.isEmpty || _isExpired(token)) {
        token = await _refreshToken(settings, url, keepConnected);
      }
    }

    return getApi(url, token);
  }

  bool _isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (error) {
      // if any error occurs, the token is considered expired
    }
    return true;
  }
}
