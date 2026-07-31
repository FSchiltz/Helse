import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/metric_type.dart';

class Metric extends HelseTable {
  // TODO start the id at 100
  TextColumn get value => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get person => integer().nullable()();
  TextColumn get sourceId => text()();
  TextColumn get source => text()();
  late final type = integer().references(MetricType, #id)();
}
