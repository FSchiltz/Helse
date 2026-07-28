import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/event_type.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Event extends HelseTable {
  TextColumn get description => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  IntColumn get person => integer().nullable()();
  TextColumn get sourceId => text()();
  TextColumn get source => text()();
  TextColumn get tag => text().nullable()();
  late final type = integer().references(EventType, #id)();
}
