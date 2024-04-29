import 'dart:core';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart';

import '../services/account.dart';

class OauthClient {
  String? _token;
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

  oauth2.AuthorizationCodeGrant _grant() {
    return oauth2.AuthorizationCodeGrant(
      _clientId ?? '',
      Uri.parse(_auth ?? ''),
      Uri.parse(_token ?? ''),
    );
  }

  Future<void> login() async {
    if (await account.getToken() != null) {
      // already auth
    } else {
      var grant = await account.getGrant();
      if (grant == null) {
        var redirect = redirectUrl.toString();
        final authUrl = '$_auth?client_id=$_clientId&response_type=code&scope=openid+profile+offline_access&state=STATE&redirect_uri=$redirect';

        await account.setRedirect(redirect);

        if (kIsWeb) {
          window.location.assign(authUrl);
        } else {
          //final String result = await FlutterWebAuth.authenticate(url: authorizationUrl.toString(), callbackUrlScheme: "de.xxx.xyz");
          _doAuthOnMobile('result');
        }
      }
    }
  }

  void _doAuthOnMobile(String result) async {
    var code = Uri.parse(result).queryParameters['code'] ?? '';
    final oauth2.Client client = await _grant().handleAuthorizationResponse({'code': code});
  }

  Future<void> doAuthOnWeb(Map<String, String> uri) async {
    var code = uri['code'] ?? '';
    await account.setGrant(code);
  }
}
