import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/metric_type.dart';
import 'package:helse/services/local/database/models/person.dart';
import 'package:helse/services/local/database/models/unit.dart';

class Metric extends HelseTable {
  // TODO start the id at 100
  TextColumn get value => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get sourceId => text()();
  TextColumn get source => text()();
  TextColumn get tag => text().nullable()();
  late final type = integer().references(MetricType, #id)();
  late final unit = integer().nullable().references(Unit, #id)();
  late final person = integer().references(Person, #id)();
}
