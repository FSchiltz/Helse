import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Unit extends HelseTable {
  TextColumn get code => text()();
  TextColumn get description => text()();
  TextColumn get type => text()();
  RealColumn get conversionFactor => real().nullable()();
  late final baseUnit = integer().references(Unit, #id).nullable()();
}
