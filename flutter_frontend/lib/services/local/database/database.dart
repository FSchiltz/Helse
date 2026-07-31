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
    show MetricDataType, UnitType, MetricSummary;
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
    });

    await batch((batch) {
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
    });

    // Metric types
    await batch((batch) {
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
  }
}
