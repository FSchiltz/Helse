import 'dart:async';
import 'dart:developer';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../di/dependencies.dart';
import 'account.dart';

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
          Dependencies.logics.authentication.logOut(false);
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

  Future<String?> _refreshToken(ConnectionResponse? settings, Uri url) async {
    var client = Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({
          'Authorization': 'Bearer ${settings?.refreshToken}',
        }),
      ],
    );
    var response = await client.apiRefreshGet();
    var connection = response.body;
    if (connection != null) {
      var token = ConnectionResponse(
        id: connection.id,
        accessToken: connection.accessToken,
        roles: connection.roles,
        refreshToken: settings?.refreshToken,
      );
      await account.setToken(token);
      return token.accessToken;
    }
    return null;
  }

  Future<Helseapi> getService({Uri? override, bool sendRefresh = false}) async {
    var url = override ?? Uri.parse(account.get(Account.url) ?? '');

    // first we try to get a new refresh token if needed
    String? token;
    var settings = account.getToken();

    if (sendRefresh) {
      token = settings?.refreshToken;
    } else {
      token = settings?.accessToken;
      if (token == null || token.isEmpty || _isExpired(token)) {
        token = await _refreshToken(settings, url);
      }
    }
    return Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({'Authorization': 'Bearer $token'}),
      ],
    );
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
