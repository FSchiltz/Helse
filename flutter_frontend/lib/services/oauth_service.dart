import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/api_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account.dart';

class OauthService extends ApiService {
  String? _auth;
  String? _clientId;

  OauthService(super.account);

  Uri get redirectUrl {
    if (kIsWeb) {
      return Uri.base;
    } else {
      return Uri.parse('com.helse://login-callback');
    }
  }

  void init({required String auth, required String clientId}) async {
    _auth = auth;
    _clientId = clientId;
  }

  String getRandomString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<String?> getGrant(String url, OauthConnection oauth) async {
    init(auth: oauth.url, clientId: oauth.clientId);
    await account.set(Account.url, url);

    var grant = await account.get(Account.grant);
    if (grant == null) {
      var state = getRandomString(24);
      var redirect = redirectUrl.toString();
      final authUrl =
          '$_auth?client_id=$_clientId&response_type=code&scope=openid+profile+offline_access&state=$state&redirect_uri=$redirect';

      await account.set(Account.redirect, redirect);
      await account.set(Account.clientid, _clientId ?? '');

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

  Future<String> getCode(Map<String, String> uri) async {
    var code = uri['code'] ?? '';
    await account.set(Account.grant, code);
    return code;
  }

  void doAuthOnWeb(Map<String, String> uri) => getCode(uri);

  Future<void> _redirect(String authUrl) async {
    Dependencies.logics.authentication.set(AuthenticationStatus.unknown);
    var uri = Uri.parse(authUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
