import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/metric.dart';
import 'package:helse/services/local/database/models/unit.dart';

class MetricType extends HelseTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  late final groupId = integer().references(Group, #id)();
  TextColumn get timeDifference => text().nullable()();
  BoolColumn get visible => boolean()();
  IntColumn get valueCount => integer().nullable()();
  BoolColumn get showOnDashboard => boolean()();
  BoolColumn get userEditable => boolean()();
  TextColumn get summaryType => text()();
  TextColumn get type => text()();
  late final unit = integer().references(Unit, #id)();
}
