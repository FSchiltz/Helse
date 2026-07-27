import 'package:drift/drift.dart';
import 'package:helse/services/local/database/models/helse_table.dart';

class Person extends HelseTable {
  TextColumn get identifier => text().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get types => text().nullable()();
  TextColumn get surname => text().nullable()();
  DateTimeColumn get birth => dateTime().nullable()();
  TextColumn get profilePicture => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
}
