import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:helse/services/local/database/models/event.dart';
import 'package:helse/services/local/database/models/event_type.dart';
import 'package:helse/services/local/database/models/group.dart';
import 'package:helse/services/local/database/models/job.dart';
import 'package:helse/services/local/database/models/metric.dart';
import 'package:helse/services/local/database/models/metric_type.dart';
import 'package:helse/services/local/database/models/person.dart';
import 'package:helse/services/local/database/models/unit.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart'
    show UnitType;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Metric, Event, MetricType, EventType, Job, Unit, Person, Group],
)
class Database extends _$Database {
  Database([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'helse',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: _fillData,
    );
  }

  Future<void> _fillData(Migrator m) async {
    await m.createAll();

    await batch((batch) {
      batch.insertAll(unit, [
        UnitCompanion.insert(
          id: Value(0),
          code: '',
          description: 'None',
          type: 0,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(1),
          code: 'm',
          description: 'Meter',
          type: 1,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(2),
          code: 'cm',
          description: 'Centimeter',
          type: 1,
          baseUnit: const Value(1),
          conversionFactor: const Value(0.01),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(3),
          code: 'mm',
          description: 'Millimeter',
          type: 1,
          baseUnit: const Value(1),
          conversionFactor: const Value(0.001),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(4),
          code: 'km',
          description: 'Kilometer',
          type: 1,
          baseUnit: const Value(1),
          conversionFactor: const Value(1000),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(5),
          code: 'g',
          description: 'Gram',
          type: 2,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(6),
          code: 'kg',
          description: 'Kilogram',
          type: 2,
          baseUnit: const Value(5),
          conversionFactor: const Value(1000),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(7),
          code: 'mg',
          description: 'Milligram',
          type: 2,
          baseUnit: const Value(5),
          conversionFactor: const Value(0.001),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(8),
          code: 'bpm',
          description: 'BPM',
          type: 3,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(9),
          code: 'C',
          description: 'Celsius',
          type: 4,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(10),
          code: 'kcal',
          description: 'Calories',
          type: 5,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
        UnitCompanion.insert(
          id: Value(11),
          code: '%',
          description: 'Percent',
          type: 6,
          baseUnit: const Value.absent(),
          conversionFactor: const Value.absent(),
          created: DateTime.now().toUtc(),
        ),
      ]);
    });

    // Metric types
    await batch((batch) {
      batch.insertAll(metricType, [
        MetricTypeCompanion.insert(
          name: 'Heart',
          unit: const Value('bpm'),
          type: 1,
          summaryType: 0,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Oxygen',
          unit: const Value('%'),
          type: 1,
          summaryType: 0,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Weight',
          unit: const Value('Kg'),
          type: 1,
          summaryType: 0,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Height',
          unit: const Value('m'),
          type: 1,
          summaryType: 0,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Temperature',
          unit: const Value('C'),
          type: 1,
          summaryType: 0,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Steps',
          unit: const Value(''),
          type: 1,
          summaryType: 1,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Calories',
          unit: const Value('kcal'),
          type: 1,
          summaryType: 1,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
        MetricTypeCompanion.insert(
          name: 'Distance',
          unit: const Value('m'),
          type: 1,
          summaryType: 1,
          description: const Value.absent(),
          created: DateTime.now().toUtc(),
          visible: true,
          showOnDashboard: true,
          userEditable: false,
        ),
      ]);

      // Event types
      batch.insertAll(eventType, [
        EventTypeCompanion.insert(
          name: 'Sleep',
          standalone: true,
          description: const Value.absent(),
        ),
        EventTypeCompanion.insert(
          name: 'Care',
          standalone: true,
          description: const Value.absent(),
        ),
      ]);
    });

    await into(unit).insert(
      UnitCompanion.insert(
        created: DateTime.now().toUtc(),
        code: '',
        type: UnitType.none.name,
        description: Value('None'),
      ),
    );
  }
}
