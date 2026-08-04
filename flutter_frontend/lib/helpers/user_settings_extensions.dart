import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

extension UserSettingsExtensions on UserSettings {
  UserSettings normalized() => copyWith(
        datePreset: datePreset ?? DatePreset.today,
        theme: theme ?? InterfaceTheme.system,
        version: version ?? 2,
      );
}

extension PatientSettingsExtensions on PatientSettings {
  PatientSettings normalized() => copyWith(
        datePreset: datePreset ?? DatePreset.today,
        theme: theme ?? InterfaceTheme.system,
        version: version ?? 2,
      );
}
