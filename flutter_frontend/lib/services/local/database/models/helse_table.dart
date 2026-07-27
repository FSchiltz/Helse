import 'package:drift/drift.dart';

class TrackedTable extends Table {
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncTime => dateTime().nullable()();

  IntColumn get serverId => integer().nullable()();

  DateTimeColumn get created => dateTime()();
}

class HelseTable extends TrackedTable {
  IntColumn get id => integer().autoIncrement()();
}
