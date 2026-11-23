import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/local/database/database.dart';
import 'package:helse/services/local/local_cache_service.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart'
    as enums;
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart'
    as api;

class _TestCacheService extends LocalCacheService {
  _TestCacheService(super.account, this.testDatabase);

  final Database testDatabase;

  @override
  Database get database => testDatabase;
}

void main() {
  test('saves metric types with their group and unit dependencies', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);
    final cache = _TestCacheService(Account(), database);

    await cache.saveMetricTypes([
      api.MetricType(
        id: 20,
        unit: const api.Unit(
          id: 36074,
          type: enums.UnitType.frequency,
          code: 'bpm',
        ),
        userEditable: false,
        name: 'Heart',
        summaryType: enums.MetricSummary.mean,
        type: enums.MetricDataType.number,
        visible: true,
        showOnDashboard: true,
        groupId: 200,
      ),
    ]);

    final metricType = await (database.select(
      database.metricType,
    )..where((row) => row.serverId.equals(20))).getSingle();
    final group = await (database.select(
      database.group,
    )..where((row) => row.id.equals(metricType.groupId))).getSingleOrNull();
    final unit = await (database.select(
      database.unit,
    )..where((row) => row.id.equals(metricType.unit))).getSingleOrNull();

    expect(group, isNotNull);
    expect(unit, isNotNull);
  });

  test('links saved files to a metric using its local ID', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);
    final cache = _TestCacheService(Account(), database);
    final metricId = await database
        .into(database.metric)
        .insert(
          MetricCompanion.insert(
            id: const Value(42),
            person: 0,
            type: 1,
            unit: const Value(8),
            date: DateTime.utc(2026),
            value: '70',
            source: 'none',
            sourceId: '',
            created: DateTime.utc(2026),
            synced: const Value(true),
            serverId: const Value(1286205),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );

    await cache.saveFiles(
      [
        api.File(
          id: 2,
          name: 'result',
          description: '',
          start: DateTime.utc(2026),
          created: DateTime.utc(2026),
        ),
      ],
      0,
      metricId: 1286205,
    );

    final link = await (database.select(
      database.metricFiles,
    )..where((row) => row.metric.equals(metricId))).getSingle();
    expect(link.file, 2);
  });

  test('skips cached files with the invalid server ID zero', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);
    final cache = _TestCacheService(Account(), database);
    await database
        .into(database.metric)
        .insert(
          MetricCompanion.insert(
            id: const Value(42),
            person: 0,
            type: 1,
            unit: const Value(8),
            date: DateTime.utc(2026),
            value: '70',
            source: 'none',
            sourceId: '',
            created: DateTime.utc(2026),
            synced: const Value(true),
            serverId: const Value(1286202),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );

    await cache.saveFiles(
      [
        api.File(
          id: 0,
          name: 'invalid',
          description: '',
          start: DateTime.utc(2026),
          created: DateTime.utc(2026),
        ),
      ],
      0,
      metricId: 1286202,
    );

    expect(await database.select(database.file).get(), isEmpty);
    expect(await database.select(database.metricFiles).get(), isEmpty);
  });

  test('skips file links when a cached file maps to local ID zero', () async {
    final database = Database(NativeDatabase.memory());
    addTearDown(database.close);
    final cache = _TestCacheService(Account(), database);
    await database
        .into(database.metric)
        .insert(
          MetricCompanion.insert(
            id: const Value(1286202),
            person: 0,
            type: 1,
            unit: const Value(8),
            date: DateTime.utc(2026),
            value: '70',
            source: 'none',
            sourceId: '',
            created: DateTime.utc(2026),
            synced: const Value(true),
            serverId: const Value(1286202),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );
    await database
        .into(database.file)
        .insert(
          FileCompanion.insert(
            id: const Value(0),
            type: 'none',
            dataType: '',
            name: 'cached',
            description: '',
            start: DateTime.utc(2026),
            valid: true,
            person: 0,
            created: DateTime.utc(2026),
            synced: const Value(true),
            serverId: const Value(7),
            syncTime: Value(DateTime.now().toUtc()),
          ),
        );

    await cache.saveFiles(
      [
        api.File(
          id: 7,
          name: 'cached',
          description: '',
          start: DateTime.utc(2026),
          created: DateTime.utc(2026),
        ),
      ],
      0,
      metricId: 1286202,
    );

    expect(await database.select(database.metricFiles).get(), isEmpty);
  });
}
