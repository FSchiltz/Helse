import 'package:drift/drift.dart';

class PendingDeletion extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  IntColumn get serverId => integer()();
  IntColumn get relatedId => integer().nullable()();
  DateTimeColumn get created => dateTime()();
}
