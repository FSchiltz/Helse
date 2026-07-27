import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/event_type.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Metric extends HelseTable {
  TextColumn get value => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get person => integer().nullable()();
  late final type = integer().references(MetricType, #id)();
}

class Event extends HelseTable {
  TextColumn get description => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  IntColumn get person => integer().nullable()();
  late final type = integer().references(EventType, #id)();
}

class MetricType extends HelseTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  late final groupId = integer().references(Group, #id)();
}

class Group extends HelseTable {
  TextColumn get name => text()();
  TextColumn get description => text()();
  BoolColumn get showOnDashboard => boolean()();
  BoolColumn get showTitle => boolean()();
}
