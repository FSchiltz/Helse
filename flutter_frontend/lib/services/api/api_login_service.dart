import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/login_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart';

class ApiLoginService extends ApiService implements LoginService {
  ApiLoginService(super.account);

  @override
  Future<ConnectionResponse?> login(Connection connection) async {
    var api = await getService();
    var response = await api.apiAuthPost(body: connection);

    switch (response.statusCode) {
      case 401:
        throw ArgumentError("Incorrect username or password");
      case 200:
        return response.body;
      default:
        throw StateError(response.error?.toString() ?? "Error");
    }
  }


  @override
  Uri get redirectUrl {
    if (kIsWeb) {
      return Uri.base;
    } else {
      return Uri.parse('com.helse://login-callback');
    }
  }

  String _getRandomString(int len) {
    final random = Random.secure();
    final values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  @override
  Future<String?> getGrant(String url, OauthConnection oauth) async {
    await account.set(Account.url, url);

    final grant = account.get(Account.grant);
    if (grant == null) {
      final state = _getRandomString(24);
      final redirect = redirectUrl.toString();
      final authUrl =
          '${oauth.url}?client_id=${oauth.clientId}&response_type=code&scope=openid+profile+offline_access&state=$state&redirect_uri=$redirect';

      await account.set(Account.redirect, redirect);
      await account.set(Account.clientid, oauth.clientId);

      if (kIsWeb) {
        window.location.assign(authUrl);
        return null;
      } else {
        await _redirect(authUrl);
        return null;
      }
    } else {
      return grant;
    }
  }

  @override
  Future<String?> getCode(Map<String, String> uri) async {
    final code = uri['code'];
    if (code != null) await account.set(Account.grant, code);
    return code;
  }

  Future<void> _redirect(String authUrl) async {
    Dependencies.logics.authentication.resetAuth();
    final uri = Uri.parse(authUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }


  @override
  Future<Status?> isInit(Uri url) async {
    final api = getApi(url, null);
    final response = await api.apiStatusGet();

    if (!response.isSuccessful) return null;

    return response.bodyOrThrow;
  }
}
