import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/event.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/metric.dart';
import 'package:helse/services/local/database/models/person.dart';

class File extends HelseTable {
  TextColumn get type => text()();
  TextColumn get dataType => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
  BoolColumn get valid => boolean()();

  late final person = integer().references(Person, #id)();
}

class EventFiles extends HelseTable {
  late final file = integer().references(File, #id)();
  late final event = integer().references(Event, #id)();
}

class MetricFiles extends HelseTable {
  late final file = integer().references(File, #id)();
  late final metric = integer().references(Metric, #id)();
}
