import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
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
          _account.removeToken();
          result = null;
          break;
        default:
          throw Exception(response.error);
      }
    } else {
      result = response.body;
    }
    return result;
  }

  Future<Swagger> getService({String? override}) async {
    var url = override ?? await _account.getUrl();
    if (url == null) throw Exception("Url missing");

    var token = await _account.getToken();
    return Swagger.create(baseUrl: Uri.parse(url), interceptors: [
      HeadersInterceptor({'Authorization': 'Bearer $token'})
    ]);
  }
}
