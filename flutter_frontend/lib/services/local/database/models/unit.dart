import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Unit extends HelseTable {
  TextColumn get code => text()();

  TextColumn get type => text()();
}
