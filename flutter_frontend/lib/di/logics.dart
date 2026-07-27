import 'package:helse/logic/file_logic.dart';
import 'package:helse/logic/account/authentication_logic.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/import_logic.dart';
import 'package:helse/logic/settings/patients_settings_logic.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/account.dart';

class Logics {
  AuthenticationLogic authentication;
  ImportLogic import = ImportLogic();
  HealthConnectLogic health;
  SettingsLogic settings;
  PatientsSettingsLogic patientsSettings;
  FileLogic files;

  Logics.build(
    this.authentication,
    this.settings,
    this.health,
    this.patientsSettings,
    this.files
  );

  factory Logics(Account account) {
    final settings = SettingsLogic(account);
    return Logics.build(
      AuthenticationLogic(account),
      settings,
      HealthConnectLogic(settings),
      PatientsSettingsLogic(account),
      FileLogic()
    );
  }
}
