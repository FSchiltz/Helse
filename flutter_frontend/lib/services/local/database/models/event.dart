import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/event_type.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/person.dart';

class Event extends HelseTable {
  TextColumn get description => text().nullable()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  late final person = integer().references(Person, #id)();
  TextColumn get sourceId => text()();
  TextColumn get source => text()();
  TextColumn get tag => text().nullable()();
  DateTimeColumn get notificationTime => dateTime().nullable()();
  late final type = integer().references(EventType, #id)();
}
