import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:helse/services/local/database/models/event.dart';
import 'package:helse/services/local/database/models/event_type.dart';
import 'package:helse/services/local/database/models/file.dart';
import 'package:helse/services/local/database/models/group.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/job.dart';
import 'package:helse/services/local/database/models/metric.dart';
import 'package:helse/services/local/database/models/metric_type.dart';
import 'package:helse/services/local/database/models/person.dart';
import 'package:helse/services/local/database/models/pending_deletion.dart';
import 'package:helse/services/local/database/models/unit.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart'
    show MetricDataType, UnitType, MetricSummary;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Metric,
    Event,
    MetricType,
    EventType,
    Job,
    Unit,
    Person,
    Group,
    File,
    MetricFiles,
    EventFiles,
    PendingDeletion,
  ],
)
class Database extends _$Database {
  Database([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static const cacheValidity = Duration(days: 30);

  @override
  int get schemaVersion => 3;

  Future<void> expireServerCache({DateTime? now}) async {
    final cutoff = (now ?? DateTime.now().toUtc()).toUtc().subtract(
      cacheValidity,
    );

    await transaction(() async {
      final eventQuery = selectOnly(event)..addColumns([event.id]);
      eventQuery.where(_isExpired(event, cutoff));
      final expiredEventIds = _ids(
        await eventQuery.map((row) => row.read(event.id)).get(),
      );

      final metricQuery = selectOnly(metric)..addColumns([metric.id]);
      metricQuery.where(_isExpired(metric, cutoff));
      final expiredMetricIds = _ids(
        await metricQuery.map((row) => row.read(metric.id)).get(),
      );

      final fileQuery = selectOnly(file)..addColumns([file.id]);
      fileQuery.where(_isExpired(file, cutoff));
      final expiredFileIds = _ids(
        await fileQuery.map((row) => row.read(file.id)).get(),
      );

      await (delete(eventFiles)..where(
            (row) =>
                row.event.isIn(expiredEventIds) | row.file.isIn(expiredFileIds),
          ))
          .go();
      await (delete(metricFiles)..where(
            (row) =>
                row.metric.isIn(expiredMetricIds) |
                row.file.isIn(expiredFileIds),
          ))
          .go();
      await (delete(event)..where((row) => row.id.isIn(expiredEventIds))).go();
      await (delete(
        metric,
      )..where((row) => row.id.isIn(expiredMetricIds))).go();
      await (delete(file)..where((row) => row.id.isIn(expiredFileIds))).go();

      final eventTypeQuery = selectOnly(eventType)
        ..addColumns([eventType.id])
        ..where(_isExpired(eventType, cutoff));
      final expiredEventTypeIds = _ids(
        await eventTypeQuery.map((row) => row.read(eventType.id)).get(),
      );
      final eventTypeReferences = selectOnly(event)..addColumns([event.type]);
      final referencedEventTypes = _ids(
        await eventTypeReferences.map((row) => row.read(event.type)).get(),
      );
      await (delete(eventType)..where(
            (row) => row.id.isIn(
              expiredEventTypeIds.difference(referencedEventTypes),
            ),
          ))
          .go();

      final metricTypeQuery = selectOnly(metricType)
        ..addColumns([metricType.id])
        ..where(_isExpired(metricType, cutoff));
      final expiredMetricTypeIds = _ids(
        await metricTypeQuery.map((row) => row.read(metricType.id)).get(),
      );
      final metricTypeReferences = selectOnly(metric)
        ..addColumns([metric.type]);
      final referencedMetricTypes = _ids(
        await metricTypeReferences.map((row) => row.read(metric.type)).get(),
      );
      await (delete(metricType)..where(
            (row) => row.id.isIn(
              expiredMetricTypeIds.difference(referencedMetricTypes),
            ),
          ))
          .go();

      final unitQuery = selectOnly(unit)
        ..addColumns([unit.id])
        ..where(_isExpired(unit, cutoff));
      final expiredUnitIds = _ids(
        await unitQuery.map((row) => row.read(unit.id)).get(),
      );
      final metricTypeUnits = selectOnly(metricType)
        ..addColumns([metricType.unit]);
      final referencedUnits = _ids(
        await metricTypeUnits.map((row) => row.read(metricType.unit)).get(),
      );
      final unitBaseUnits = selectOnly(unit)..addColumns([unit.baseUnit]);
      final baseUnits = _ids(
        await unitBaseUnits.map((row) => row.read(unit.baseUnit)).get(),
      );
      await (delete(unit)..where(
            (row) => row.id.isIn(
              expiredUnitIds.difference(referencedUnits).difference(baseUnits),
            ),
          ))
          .go();

      final groupQuery = selectOnly(group)
        ..addColumns([group.id])
        ..where(_isExpired(group, cutoff));
      final expiredGroupIds = _ids(
        await groupQuery.map((row) => row.read(group.id)).get(),
      );
      final eventTypeGroups = selectOnly(eventType)
        ..addColumns([eventType.groupId]);
      final metricTypeGroups = selectOnly(metricType)
        ..addColumns([metricType.groupId]);
      final referencedGroups = {
        ..._ids(
          await eventTypeGroups.map((row) => row.read(eventType.groupId)).get(),
        ),
        ..._ids(
          await metricTypeGroups
              .map((row) => row.read(metricType.groupId))
              .get(),
        ),
      };
      await (delete(group)..where(
            (row) => row.id.isIn(expiredGroupIds.difference(referencedGroups)),
          ))
          .go();

      final personQuery = selectOnly(person)
        ..addColumns([person.id])
        ..where(_isExpired(person, cutoff));
      final expiredPersonIds = _ids(
        await personQuery.map((row) => row.read(person.id)).get(),
      );
      final eventPeople = selectOnly(event)..addColumns([event.person]);
      final metricPeople = selectOnly(metric)..addColumns([metric.person]);
      final filePeople = selectOnly(file)..addColumns([file.person]);
      final referencedPeople = {
        ..._ids(await eventPeople.map((row) => row.read(event.person)).get()),
        ..._ids(await metricPeople.map((row) => row.read(metric.person)).get()),
        ..._ids(await filePeople.map((row) => row.read(file.person)).get()),
      };
      await (delete(person)..where(
            (row) => row.id.isIn(expiredPersonIds.difference(referencedPeople)),
          ))
          .go();
    });
  }

  Set<int> _ids(Iterable<int?> values) => values.whereType<int>().toSet();

  Expression<bool> _isExpired(TrackedTable row, DateTime cutoff) =>
      row.synced.equals(true) &
      row.serverId.isNotNull() &
      (row.syncTime.isNull() | row.syncTime.isSmallerThanValue(cutoff));

  static Future<String> databasePath() async {
    var baseDir = await getApplicationSupportDirectory();

    return "${baseDir.path}/helse.sqlite";
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'helse',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(pendingDeletion);
        }
        if (from >= 2 && from < 3) {
          await m.addColumn(pendingDeletion, pendingDeletion.relatedId);
        }
        if (from < 3) {
          await customStatement(
            'UPDATE "group" SET synced = 1 WHERE id BETWEEN 1 AND 6',
          );
          await customStatement(
            'UPDATE metric_type SET synced = 1 WHERE id BETWEEN 1 AND 19',
          );
          await customStatement(
            'UPDATE event_type SET synced = 1 WHERE id BETWEEN 1 AND 5',
          );
          await customStatement(
            'UPDATE unit SET synced = 1 WHERE id BETWEEN 0 AND 11',
          );
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: _fillData,
    );
  }

  Future<void> _fillData(Migrator m) async {
    await m.createAll();

    await batch((batch) {
      batch.insert(
        person,
        PersonCompanion.insert(
          created: DateTime.now().toUtc(),
          identifier: "Main",
          id: Value(0),
        ),
      );
      batch.insertAll(unit, [
        UnitCompanion.insert(
          id: Value(0),
          code: '',
          description: 'None',
          type: UnitType.none.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(1),
          code: 'm',
          description: 'Meter',
          type: UnitType.distance.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(2),
          code: 'cm',
          description: 'Centimeter',
          type: UnitType.distance.name,
          baseUnit: const Value(1),
          conversionFactor: const Value(0.01),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(3),
          code: 'mm',
          description: 'Millimeter',
          type: UnitType.distance.name,
          baseUnit: const Value(1),
          conversionFactor: const Value(0.001),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(4),
          code: 'km',
          description: 'Kilometer',
          type: UnitType.distance.name,
          baseUnit: const Value(1),
          conversionFactor: const Value(1000),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(5),
          code: 'g',
          description: 'Gram',
          type: UnitType.wheight.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(6),
          code: 'kg',
          description: 'Kilogram',
          type: UnitType.wheight.name,
          baseUnit: const Value(5),
          conversionFactor: const Value(1000),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(7),
          code: 'mg',
          description: 'Milligram',
          type: UnitType.wheight.name,
          baseUnit: const Value(5),
          conversionFactor: const Value(0.001),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(8),
          code: 'bpm',
          description: 'BPM',
          type: UnitType.frequency.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(9),
          code: 'C',
          description: 'Celsius',
          type: UnitType.temperature.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(10),
          code: 'kcal',
          description: 'Calories',
          type: UnitType.power.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(11),
          code: '%',
          description: 'Percent',
          type: UnitType.factor.name,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
      ]);

      batch.insertAll(group, [
        GroupCompanion.insert(
          id: Value(1),
          name: 'Other',
          description: '',
          showTitle: false,
          showOnDashboard: false,
          created: DateTime.now().toUtc(),
        ),
        GroupCompanion.insert(
          id: Value(2),
          name: 'Measure',
          description: '',
          showTitle: false,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
        GroupCompanion.insert(
          id: Value(3),
          name: 'Women Health',
          description: '',
          showTitle: true,
          showOnDashboard: false,
          created: DateTime.now().toUtc(),
        ),
        GroupCompanion.insert(
          id: Value(4),
          name: 'Activity',
          description: '',
          showTitle: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
        GroupCompanion.insert(
          id: Value(5),
          name: 'Treatments',
          description: '',
          showTitle: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
        GroupCompanion.insert(
          id: Value(6),
          name: 'Sleep',
          description: '',
          showTitle: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
      ]);

      batch.insertAll(metricType, [
        MetricTypeCompanion.insert(
          id: Value(1),
          name: 'Heart',
          unit: 8,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 2,
        ),
        MetricTypeCompanion.insert(
          id: Value(2),
          name: 'Oxygen',
          unit: 11,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 2,
        ),
        MetricTypeCompanion.insert(
          id: Value(3),
          name: 'Weight',
          unit: 6,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 2,
        ),
        MetricTypeCompanion.insert(
          id: Value(4),
          name: 'Height',
          unit: 1,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 2,
        ),
        MetricTypeCompanion.insert(
          id: Value(5),
          name: 'Temperature',
          unit: 9,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 2,
        ),
        MetricTypeCompanion.insert(
          id: Value(6),
          name: 'Steps',
          unit: 0,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.sum.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 4,
        ),
        MetricTypeCompanion.insert(
          id: Value(7),
          name: 'Calories',
          unit: 10,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.sum.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 4,
        ),
        MetricTypeCompanion.insert(
          id: Value(8),
          name: 'Distance',
          unit: 1,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.sum.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 4,
        ),
        MetricTypeCompanion.insert(
          id: Value(9),
          name: 'Menstruation',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 3,
        ),
        MetricTypeCompanion.insert(
          id: Value(10),
          name: 'Pain',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 3,
        ),
        MetricTypeCompanion.insert(
          id: Value(11),
          name: 'Mood',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 3,
        ),
        MetricTypeCompanion.insert(
          id: Value(12),
          name: 'Medication',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 1,
        ),
        MetricTypeCompanion.insert(
          id: Value(13),
          name: 'Tests',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 5,
        ),
        MetricTypeCompanion.insert(
          id: Value(14),
          name: 'Sex',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 1,
        ),
        MetricTypeCompanion.insert(
          id: Value(15),
          name: 'Mood',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 1,
        ),
        MetricTypeCompanion.insert(
          id: Value(16),
          name: 'Spotting',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
          groupId: 3,
        ),

        MetricTypeCompanion.insert(
          id: Value(17),
          description: const Value.absent(),
          name: 'Head Diameter',
          unit: 2,
          type: MetricDataType.number.name,
          summaryType: MetricSummary.latest.name,
          userEditable: false,
          groupId: 2,
          visible: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
        MetricTypeCompanion.insert(
          id: Value(18),
          description: const Value.absent(),
          name: 'Diapper',
          unit: 0,
          type: MetricDataType.text.name,
          summaryType: MetricSummary.latest.name,
          userEditable: false,
          groupId: 1,
          visible: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
        MetricTypeCompanion.insert(
          id: Value(19),
          description: const Value.absent(),
          name: 'Blood pressure',
          type: MetricDataType.numberrange.name,
          summaryType: MetricSummary.latest.name,
          unit: 0,
          userEditable: false,
          groupId: 2,
          valueCount: Value(2),
          visible: true,
          showOnDashboard: true,
          created: DateTime.now().toUtc(),
        ),
      ]);

      // Event types
      batch.insertAll(eventType, [
        EventTypeCompanion.insert(
          id: Value(1),
          name: 'Sleep',
          standAlone: true,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          userEditable: true,
          groupId: 6,
        ),
        EventTypeCompanion.insert(
          id: Value(2),
          name: 'Care',
          standAlone: true,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          userEditable: false,
          visible: true,
          groupId: 5,
        ),
        EventTypeCompanion.insert(
          id: Value(3),
          name: 'Workout',
          standAlone: true,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          userEditable: false,
          visible: true,
          groupId: 4,
        ),
        EventTypeCompanion.insert(
          id: Value(4),
          description: const Value.absent(),
          name: 'Bath',
          standAlone: true,
          userEditable: false,
          visible: true,
          groupId: 1,
          created: DateTime.now().toUtc(),
        ),
        EventTypeCompanion.insert(
          id: Value(5),
          description: const Value.absent(),
          name: 'Feeding',
          standAlone: true,
          visible: true,
          groupId: 1,
          userEditable: false,
          created: DateTime.now().toUtc(),
        ),
      ]);
    });

    await customStatement('UPDATE "group" SET synced = 1');
    await customStatement('UPDATE metric_type SET synced = 1');
    await customStatement('UPDATE event_type SET synced = 1');
    await customStatement('UPDATE unit SET synced = 1');
  }
}
