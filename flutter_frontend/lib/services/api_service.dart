import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../di/dependencies.dart';
import 'account.dart';

abstract class ApiService {
  final Account account;

  ApiService(this.account);

  Future<T?> call<T>(Future<Response<T>> Function() call) async {
    var response = await call();
    T? result;

    if (!response.isSuccessful) {
      switch (response.statusCode) {
        case 401:
          // no auth, we remove the token and return null;
          Dependencies.logics.authentication.logOut();
          result = null;
          break;
        default:
          throw StateError(response.error?.toString() ?? "Login error");
      }
    } else {
      result = response.body;
    }
    return result;
  }

  Future<String?> _refreshToken() async {
    var url = Uri.parse(await account.get(Account.url) ?? '');
    var refresh = await account.getToken();
    var client = Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({'Authorization': 'Bearer ${refresh?.refreshToken}'}),
      ],
    );
    var response = await client.apiRefreshGet();
    var connection = response.body;
    if (connection != null) {
      var token = ConnectionResponse(
        accessToken: connection.accessToken,
        roles: connection.roles,
        refreshToken: refresh?.refreshToken,
      );
      await account.setToken(token);
      return token.accessToken;
    }
    return null;
  }

  Future<Helseapi> getService({Uri? override}) async {
    var url = override ?? Uri.parse(await account.get(Account.url) ?? '');

    // first we try to get a new refresh token if needed
    var token = (await account.getToken())?.accessToken;
    if (token != null && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        token = await _refreshToken();
      }
    }

    return Helseapi.create(
      baseUrl: url,
      interceptors: [
        HeadersInterceptor({'Authorization': 'Bearer $token'}),
      ],
    );
  }
}
