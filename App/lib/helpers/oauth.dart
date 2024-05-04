import 'dart:core';
import 'package:app_links/app_links.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../services/account.dart';

class OauthClient {
  String? _auth;
  String? _clientId;
  final Account account;

  OauthClient(this.account);

  void listen(Null Function(dynamic user) param0) {}

  Uri get redirectUrl {
    if (kIsWeb) {
      return Uri.base;
    } else {
      return Uri.parse('com.helse://login-callback');
    }
  }

  void init({
    required String auth,
    required String clientId,
  }) async {
    _auth = auth;
    _clientId = clientId;
  }

  Future<String?> login(url) async {
    await account.set(Account.url, url);

    var grant = await account.get(Account.grant);
    if (grant == null) {
      var redirect = redirectUrl.toString();
      final authUrl =
          '$_auth?client_id=$_clientId&response_type=code&scope=openid+profile+offline_access&state=STATE&redirect_uri=$redirect';

      await account.set(Account.redirect, redirect);

      if (kIsWeb) {
        window.location.assign(authUrl);
        return null;
      } else {
        _doAuthOnMobile(authUrl, redirect);
        return '';
      }
    } else {
      return grant;
    }
  }

  Future<void> getCode(Map<String, String> uri) async {
    var code = uri['code'] ?? '';
    await account.set(Account.grant, code);
  }

  void _doAuthOnMobile(String result, String redirect) async {
    var links = AppLinks();
    links.allUriLinkStream.listen((uri) {
      if (uri.toString().startsWith(redirect)) {
        getCode(uri.queryParameters).then((value) => DI.authentication?.setLogin());
      }
    });

    var uri = Uri.parse(result);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void doAuthOnWeb(Map<String, String> uri) => getCode(uri);
}
