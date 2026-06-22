import 'package:flutter_test/flutter_test.dart';
import 'package:helse/logic/fit/fit_logic.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/import_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
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

    fitLogic = HealthConnectLogic(settingsLogic, importService);
  });

  setUpAll(() {
    registerFallbackValue(ImportData());
  });

  test('importInChunks sends correct chunk sizes', () async {
    final captured = <ImportData>[];

    when(() => importService.importData(any())).thenAnswer((invocation) async {
      captured.add(invocation.positionalArguments.first as ImportData);

      return ImportsResult(
        metrics: ImportResult(imported: 0, skipped: 0, failed: 0),
        events: ImportResult(imported: 0, skipped: 0, failed: 0),
      );
    });

    await fitLogic.importInChunks(
      ImportData(
        metrics: List.generate(
          2500,
          (i) => CreateMetric(
            type: 1,
            value: "67868",
            date: DateTime.now(),
            sourceId: '',
          ),
        ),
        events: List.generate(
          1500,
          (i) =>
              CreateEvent(type: 2, start: DateTime.now(), stop: DateTime.now()),
        ),
      ),
    );

    expect(captured.length, 3);

    expect(captured[0].metrics!.length, 1000);
    expect(captured[0].events!.length, 1000);

    expect(captured[1].metrics!.length, 1000);
    expect(captured[1].events!.length, 500);

    expect(captured[2].metrics!.length, 500);
    expect(captured[2].events!.length, 0);
  });
}
