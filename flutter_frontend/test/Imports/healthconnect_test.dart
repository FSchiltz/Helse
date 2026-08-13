import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/fit/fit_logic.dart';
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
  });

  setUpAll(() {
  });

 }
