import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';
import 'package:helse/services/local/database/models/metric.dart';

class EventType extends HelseTable {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get standAlone => boolean()();
  BoolColumn get visible => boolean()();
  TextColumn get timeDifference => text().nullable()();
  BoolColumn get userEditable => boolean()();
  late final groupId = integer().references(Group, #id)();
}
