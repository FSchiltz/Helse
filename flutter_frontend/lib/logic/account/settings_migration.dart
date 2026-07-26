import 'dart:async';
import 'package:collection/collection.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SettingsMigration {
  final Account account;
  SettingsMigration(this.account);

  Future<void> migrate() async {
    await _migrateAuthToJon();
  }

  Future<void> _migrateAuthToJon() async {
    // migrate the tokens to the json format
    var token = account.get(Account.refresh);
    if (token == null) return;

    bool isJson = token.startsWith("{");
    if (!isJson) {
      var access = account.get("access");
      var user = account.get("user");
      List<UserType> roles = [];
      if (access != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        var data = decodedToken["roles"] as String?;
        if (data != null) {
          var splitted = data.split(';');
          roles = splitted
              .map(
                (e) =>
                    UserType.values.firstWhereOrNull((x) => x.value == e) ??
                    UserType.swaggerGeneratedUnknown,
              )
              .toList();
        }
      }
      var connection = ConnectionResponse(
        id: user ?? '',
        accessToken: access ?? '',
        roles: roles,
        refreshToken: token,
      );
      await account.setToken(connection);
      await account.remove("access");
    }
  }
}
