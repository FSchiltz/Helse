import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/import_service.dart';
import 'package:mocktail/mocktail.dart';

class MockImportService extends Mock implements ImportService {}

class MockSettingsLogic extends Mock implements SettingsLogic {}

void main() {
  late HealthConnectLogic fitLogic;
  late MockImportService importService;
  late MockSettingsLogic settingsLogic;

  setUp(() {
    importService = MockImportService();
    settingsLogic = MockSettingsLogic();

    Dependencies.init(account: Account());
    Dependencies.logics.settings = settingsLogic;
    Dependencies.services.import = importService;

    fitLogic = HealthConnectLogic(settingsLogic);
    when(
      () => settingsLogic.getHealth(),
    ).thenReturn(HealthSettings(false, false, false, {}));
  });

  test('isEnabled reflects whether health sync is enabled', () {
    expect(fitLogic.isEnabled(), isFalse);

    when(
      () => settingsLogic.getHealth(),
    ).thenReturn(HealthSettings(true, false, false, {}));

    expect(fitLogic.isEnabled(), isTrue);
  });

  test('sync skips when health sync is disabled', () async {
    final result = await fitLogic.sync();

    expect(result.state, SubmissionStatus.skipped);
    expect(result.status, 'Not enabled');
    verify(() => settingsLogic.getHealth()).called(1);
  });
}
