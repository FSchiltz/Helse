import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Group extends HelseTable {
  TextColumn get name => text()();
  TextColumn get description => text()();
  BoolColumn get showOnDashboard => boolean()();
  BoolColumn get showTitle => boolean()();
}
