import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../logic/d_i.dart';
import 'account.dart';

abstract class ApiService {
  final Account _account;

  ApiService(Account account) : _account = account;

  Future<T?> call<T>(Future<Response<T>> Function() call) async {
    var response = await call();
    T? result;

    if (!response.isSuccessful) {
      switch (response.statusCode) {
        case 401:
          // no auth, we remove the token and return null;
          // TODO get a new access_token if the refresh is still valid
          _account.remove(Account.token);
          DI.authentication.logOut();
          result = null;
          break;
        default:
          throw Exception(response.error ?? "Login error");
      }
    } else {
      result = response.body;
    }
    return result;
  }

  Future<Swagger> getService({String? override}) async {
    var url = override ?? await _account.get(Account.url);
    if (url == null) throw Exception("Url missing");

    // first we try to get a new refresh token if needed
    var token = await _account.get(Account.token);
    if (token != null && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        var refresh = await _account.get(Account.refresh);
        var client = Swagger.create(baseUrl: Uri.parse(url), interceptors: [
          HeadersInterceptor({'Authorization': 'Bearer $refresh'})
        ]);
        var response = await client.apiAuthPost(body: const Connection(user: "", password: ""));
        token = response.body?.accessToken ?? '';
        await _account.set(Account.token, token);
      }
    }

    return Swagger.create(baseUrl: Uri.parse(url), interceptors: [
      HeadersInterceptor({'Authorization': 'Bearer $token'})
    ]);
  }
}
