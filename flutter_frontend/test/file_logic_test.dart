import 'package:flutter_test/flutter_test.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/file_logic.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class _TestFileService implements FileService {
  int? createdId = 42;
  int createCalls = 0;

  @override
  Future<int?> postFile(UIFile file, int? person) async {
    createCalls++;
    return createdId;
  }

  @override
  Future<void> postFileData(int fileId, file, int? person) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({});
    final account = Account();
    await account.setup();
    await Dependencies.init(account: account);
    Dependencies.blocs.server.setOffline();
  });

  test(
    'creates a file when zero is used as the new-file ID sentinel',
    () async {
      final service = _TestFileService();
      Dependencies.services.files = service;
      final file = UIFile(null, 'report', 0, '');
      final linkedIds = <int>[];

      await FileLogic().syncFiles(
        [file],
        [],
        null,
        (id) async => linkedIds.add(id),
        (_) async {},
        (_, _) {},
      );

      expect(service.createCalls, 1);
      expect(file.id, 42);
      expect(linkedIds, [42]);
    },
  );

  test('does not link a file when creating it returns no valid ID', () async {
    final service = _TestFileService()..createdId = 0;
    Dependencies.services.files = service;
    final file = UIFile(null, 'report', 0, '');
    final linkedIds = <int>[];

    await expectLater(
      FileLogic().syncFiles(
        [file],
        [],
        null,
        (id) async => linkedIds.add(id),
        (_) async {},
        (_, _) {},
      ),
      throwsA(isA<StateError>()),
    );

    expect(linkedIds, isEmpty);
  });
}
