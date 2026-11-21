import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/api/api_service.dart';

class RefreshAuthenticator extends Authenticator {
  final ApiService _service;

  RefreshAuthenticator(this._service);

  @override
  Future<Request?> authenticate(
    Request request,
    Response<dynamic> response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode != 401) {
      return null;
    }

    final settings = _service.account.getToken();
    if (settings == null || settings.refreshToken.isEmpty) {
      return null;
    }

    final token = await _service.refreshToken(
      settings,
      request.baseUri,
      _service.account.isEnabled(Account.keepConnected),
    );
    if (token == null || token.isEmpty) {
      return null;
    }

    final headers = Map<String, String>.from(request.headers)
      ..removeWhere((name, _) => name.toLowerCase() == 'authorization')
      ..['Authorization'] = 'Bearer $token';
    return request.copyWith(headers: headers);
  }
}
