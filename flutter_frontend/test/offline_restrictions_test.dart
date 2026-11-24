import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_event_service.dart';
import 'package:helse/services/local/local_metric_service.dart';
import 'package:helse/services/local/local_user_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/logic/account/server_state.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late Account account;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({});
    account = Account();
    await account.setup();
  });

  test('server distinguishes chosen offline mode from connection loss', () {
    final server = ServerState();

    server.setOffline();
    expect(server.isUserInitiatedOffline, isFalse);

    server.setOffline(userInitiated: true);
    expect(server.isUserInitiatedOffline, isTrue);

    server.setStatus(null);
    expect(server.isUserInitiatedOffline, isFalse);
  });

  test(
    'local change flag is set and cleared by synchronization state',
    () async {
      final database = Database(NativeDatabase.memory());
      addTearDown(database.close);

      expect(await database.hasLocalChanges(), isFalse);
      await database.markLocalChanges();
      expect(await database.hasLocalChanges(), isTrue);
      await database.clearLocalChanges();
      expect(await database.hasLocalChanges(), isFalse);
    },
  );

  test('offline person creation rejects account credentials', () async {
    await expectLater(
      LocalUserService(account).addPerson(
        const PersonCreation(userName: 'offline-user', password: 'secret'),
      ),
      throwsUnsupportedError,
    );
  });

  test('offline metric type creation is rejected', () async {
    await expectLater(
      LocalMetricService(account).addMetricsType(
        const CreateMetricType(name: 'Offline type', unit: 0, groupId: 1),
      ),
      throwsUnsupportedError,
    );
  });

  test('offline event type creation is rejected', () async {
    await expectLater(
      LocalEventService(
        account,
      ).addEventsType(const CreateEventType(name: 'Offline type', groupId: 1)),
      throwsUnsupportedError,
    );
  });
}
