import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/local/database/database.dart';

void main() {
  test('expires only old server cache entries', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);

    final now = DateTime.utc(2026, 11, 22);
    final expiredAt = now.subtract(const Duration(days: 31));
    await database
        .into(database.group)
        .insert(
          GroupCompanion.insert(
            name: 'Expired server group',
            description: '',
            showOnDashboard: false,
            showTitle: false,
            created: expiredAt,
            synced: const Value(true),
            serverId: const Value(100),
            syncTime: Value(expiredAt),
          ),
        );
    await database
        .into(database.group)
        .insert(
          GroupCompanion.insert(
            name: 'Recent server group',
            description: '',
            showOnDashboard: false,
            showTitle: false,
            created: now,
            synced: const Value(true),
            serverId: const Value(101),
            syncTime: Value(now),
          ),
        );
    await database
        .into(database.group)
        .insert(
          GroupCompanion.insert(
            name: 'Local group',
            description: '',
            showOnDashboard: false,
            showTitle: false,
            created: expiredAt,
          ),
        );
    final expiredGroupId = await database
        .into(database.group)
        .insert(
          GroupCompanion.insert(
            name: 'Expired dependency group',
            description: '',
            showOnDashboard: false,
            showTitle: false,
            created: expiredAt,
            synced: const Value(true),
            serverId: const Value(102),
            syncTime: Value(expiredAt),
          ),
        );
    final expiredPersonId = await database
        .into(database.person)
        .insert(
          PersonCompanion.insert(
            identifier: 'expired-server-person',
            created: expiredAt,
            synced: const Value(true),
            serverId: const Value(102),
            syncTime: Value(expiredAt),
          ),
        );
    final expiredEventTypeId = await database
        .into(database.eventType)
        .insert(
          EventTypeCompanion.insert(
            name: 'Expired server event type',
            standAlone: false,
            visible: false,
            userEditable: false,
            groupId: expiredGroupId,
            created: expiredAt,
            synced: const Value(true),
            serverId: const Value(102),
            syncTime: Value(expiredAt),
          ),
        );
    await database
        .into(database.event)
        .insert(
          EventCompanion.insert(
            description: const Value(''),
            start: expiredAt,
            end: expiredAt,
            person: expiredPersonId,
            type: expiredEventTypeId,
            sourceId: '',
            source: 'none',
            created: expiredAt,
            synced: const Value(true),
            serverId: const Value(102),
            syncTime: Value(expiredAt),
          ),
        );

    await database.expireServerCache(now: now);

    final groups = await database.select(database.group).get();
    expect(groups.map((group) => group.name), contains('Recent server group'));
    expect(groups.map((group) => group.name), contains('Local group'));
    expect(
      groups.map((group) => group.name),
      isNot(contains('Expired server group')),
    );
    expect(
      groups.map((group) => group.name),
      isNot(contains('Expired dependency group')),
    );
    expect(
      await (database.select(
        database.event,
      )..where((event) => event.serverId.equals(102))).get(),
      isEmpty,
    );
    expect(
      await (database.select(
        database.eventType,
      )..where((eventType) => eventType.serverId.equals(102))).get(),
      isEmpty,
    );
    expect(
      await (database.select(
        database.person,
      )..where((person) => person.serverId.equals(102))).get(),
      isEmpty,
    );
  });
}
