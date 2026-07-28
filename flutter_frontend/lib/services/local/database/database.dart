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
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart' show UnitType;
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
