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
          // TODO get a new access_token if the refresh is still valid
          account.remove(Account.token);
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

  Future<Helseapi> getService({String? override}) async {
    var url = override ?? await account.get(Account.url);
    if (url == null) throw StateError("Url missing");

    // first we try to get a new refresh token if needed
    var token = await account.get(Account.token);
    if (token != null && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        var refresh = await account.get(Account.refresh);
        var client = Helseapi.create(
          baseUrl: Uri.parse(url),
          interceptors: [
            HeadersInterceptor({'Authorization': 'Bearer $refresh'}),
          ],
        );
        var response = await client.apiAuthPost(
          body: const Connection(user: "", password: ""),
        );
        token = response.body?.accessToken ?? '';
        await account.set(Account.token, token);
      }
    }

    return Helseapi.create(
      baseUrl: Uri.parse(url),
      interceptors: [
        HeadersInterceptor({'Authorization': 'Bearer $token'}),
      ],
    );
  }
}
