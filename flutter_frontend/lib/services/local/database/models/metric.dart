import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Metric extends HelseTable {
  TextColumn get value => text()();

  DateTimeColumn get date => dateTime()();

  late final type = integer().references(MetricType, #id)();
}

class Event extends HelseTable {
  TextColumn get description => text()();

  DateTimeColumn get start => dateTime()();

  DateTimeColumn get end => dateTime()();

  late final type = integer().references(EventType, #id)();
}

class EventType extends HelseTable {}

class MetricType extends HelseTable {}
