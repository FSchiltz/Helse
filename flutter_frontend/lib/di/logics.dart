import 'package:helse/di/services.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/import_logic.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/account.dart';

class Logics {
  AuthenticationLogic authentication;
  ImportLogic import = ImportLogic();
  FitLogic fit;
  SettingsLogic settings;

  Logics.build(this.authentication, this.settings, this.fit);

  factory Logics(Account account, Services service) {
    return Logics.build(
      AuthenticationLogic(account),
      SettingsLogic(account, service.settings),
      FitLogic(account),
    );
  }
}
